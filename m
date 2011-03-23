Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1CWEgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:36:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54823 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1CWEgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:36:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: Cong Wang <amwang@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
	<20110310082600.b52de7fb.rdunlap@xenotime.net>
	<4D86F3A7.8060706@redhat.com>
	<alpine.LFD.2.02.1103230026170.10549@x980>
Date: Tue, 22 Mar 2011 21:36:33 -0700
In-Reply-To: <alpine.LFD.2.02.1103230026170.10549@x980> (Len Brown's message
	of "Wed, 23 Mar 2011 00:28:21 -0400 (EDT)")
Message-ID: <m1lj06zc4u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX194ZJCkmUMyCvaryCAe3097ndrtsEJnlqY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> On Mon, 21 Mar 2011, Cong Wang wrote:
>
>> 于 2011年03月11日 00:26, Randy Dunlap 写道:
>> > On Thu, 10 Mar 2011 22:10:43 +0800 Amerigo Wang wrote:
>> > > +	acpi_addr=	[ACPI,EFI]
>> > > +			Pass the RSDP address to the kernel, mostly used
>> > > +			on machines running EFI runtime service to boot the
>> > > +			second kernel for kdump.
>> > > +
>> > 
>> > I think that "acpi_addr" is a bit too generic.  How about
>> > acpi_rsdp or acpi_root instead?
>> > 
>> 
>> Yup, I agree "acpi_rsdp" is better.
>
> This should also be [KEXEC], and the code should be #ifdef CONFIG_KEXEC
> so that sane people can exclude it from their kernels.

So far sane people don't use EFI on x86 so that is easy enough.

Eric
