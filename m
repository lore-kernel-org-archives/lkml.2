Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1BNSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:09:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65513 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1BNSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Zdc6/eo9KkNMGsuLB2wH6cefudYrQ8U8PKwActcOglJmzu2/3QOnoQdbCX3lSGv3X/
         yERklDNX2hgO5yIomAGO4mOxj/lxYSsCTb79ySQg3919LNT8ARKTWnneJKcAd41R42nm
         oOKMHYGSPIPwBFlFR7awlAIgTd4PdZL4melMU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102141756550.2826@kaball-desktop>
References: <4D50343E.1020906@kernel.org>
	<alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
	<4D504161.2060900@kernel.org>
	<4D506A85.9030802@goop.org>
	<4D50B4B5.4050505@kernel.org>
	<4D519AAA.8070309@zytor.com>
	<4D547962.8040403@goop.org>
	<4D547B74.1030302@kernel.org>
	<4D54844B.4010007@zytor.com>
	<4D5488D5.2020607@kernel.org>
	<20110214162602.GB11290@dumpdata.com>
	<AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
	<alpine.DEB.2.00.1102141756550.2826@kaball-desktop>
Date: Mon, 14 Feb 2011 10:09:54 -0800
X-Google-Sender-Auth: FKBa-vHtXN9TF1UbDE7DJeNHzWQ
Message-ID: <AANLkTinXY1vV4Wgdkahc5_vr_X00jDfAA3PKWADCsaEZ@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 9:58 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 14 Feb 2011, Yinghai Lu wrote:
>> On Mon, Feb 14, 2011 at 8:26 AM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> >> BTW: Do we really need to cleanup initial mapping between _brk_end to _end?
>> >
>> > Did you try to revert the patch and run it under your setup?
>>
>> No.
>>
>> but it should be ok.
>>
>> Assume, we can update vmlinux.lds.S to make _end to be 2M aligned as
>> Stefano suggested?
>
> That would solve the problem as long as cleanup_highmap() is not moved
> to setup_arch.

yes.
