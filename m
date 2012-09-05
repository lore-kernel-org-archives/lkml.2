Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab2IEEdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:33:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41222 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2IEEdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:33:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
	<87txvdzgur.fsf@xmission.com> <20120904202205.GA28903@srcf.ucam.org>
	<87r4qhwkx9.fsf@xmission.com> <20120904212717.GA30899@srcf.ucam.org>
	<87fw6xtp23.fsf@xmission.com> <20120904232503.GA1077@srcf.ucam.org>
Date: Tue, 04 Sep 2012 21:33:31 -0700
In-Reply-To: <20120904232503.GA1077@srcf.ucam.org> (Matthew Garrett's message
	of "Wed, 5 Sep 2012 00:25:03 +0100")
Message-ID: <871uihozqc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/JN4ZDmvv6VZ30ZaJpL+LIDS/AzbYoTM8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0049]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Tue, Sep 04, 2012 at 03:12:52PM -0700, Eric W. Biederman wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> > The driving force behind this code right now is that our choices are 
>> > either (1) do something like this, or (2) disable kexec entirely.
>> 
>> Actually there is an interesting question here. Why does even EFI secure
>> boot justify this?  If I install my own key in EFI I should be able to
>> boot a kernel that does anything I want it to.   My machine doing what I
>> want it to is the point of trusted boot is it not?
>
> The full implementation should trust keys that are trusted by the 
> platform, so it'd boot any kexec image you cared to sign. Or simply 
> patch this code out and rebuild and self-sign, or disable the code that 
> turns off the capability when in secure boot mode. I've no objection to 
> putting that behind an #ifdef.

I will be happy to see a version of kexec that accepts signed images,
allowing the functionality to work in your brave new world where
everything must be signed.

Until then I don't see a point in merging anything else.

I will be happy to see some reasonable patchs for signing support on the
kexec path.

Eric
