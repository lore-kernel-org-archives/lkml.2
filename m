Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1CUIFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:05:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36665 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1CUIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:05:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cong Wang <amwang@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Len Brown <lenb@kernel.org>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
	<20110310143923.GB29464@redhat.com> <m1oc5ig90b.fsf@fess.ebiederm.org>
	<20110310185019.GB23105@srcf.ucam.org> <4D86F2C2.9080707@redhat.com>
Date: Mon, 21 Mar 2011 01:05:04 -0700
In-Reply-To: <4D86F2C2.9080707@redhat.com> (Cong Wang's message of "Mon, 21
	Mar 2011 14:40:02 +0800")
Message-ID: <m1hbawkifj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX197yiOIkFjMPIsO7gGfh8Nm0iY+f5vViuk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cong Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> Eric, any comments?

You have my Nack.

We are doing stupid and unnecessary things, that cause us problems with
EFI.  If we stop doing those stupid and unnecessary things we won't have
problems.

So I don't see the point of adding more stupid and unnecessary work, so
we can continue to do stupid and unnecessary things and cause ourselves
problems.

Eric
