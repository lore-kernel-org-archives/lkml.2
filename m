Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2IDUNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:13:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51218 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2IDUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:13:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
Date: Tue, 04 Sep 2012 13:13:32 -0700
In-Reply-To: <1346774117-2277-8-git-send-email-mjg@redhat.com> (Matthew
	Garrett's message of "Tue, 4 Sep 2012 11:55:13 -0400")
Message-ID: <87txvdzgur.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18S61gpapYbQ+1yxGBt1VmfJjyXZ0FVZqE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Matthew Garrett <mjg@redhat.com> writes:

> kexec could be used as a vector for a malicious user to use a signed kernel
> to circumvent the secure boot trust model. In the long run we'll want to
> support signed kexec payloads, but for the moment we should just disable
> loading entirely in that situation.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This makes no sense.  The naming CAP_SECURE_FIRMWARE is attrocious,
you aren't implementing or enforcing secure firmware.

You don't give any justification for this other than to support some
silly EFI feature.  Why would anyone want this if we were not booting
under EFI?

Eric
