Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1DHMdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:33:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55130 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1DHMdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TI8glPXxKwOAmClKjyvh3Gy843CdFUocmSm94lZlqnSLDi2o69VyJbZBaWQ/IU+wl+
         tcsZKkZ1mjV6L8bhgt6DDubJ+vAPwX80DWpSvDQEiyReHy90xledhIXSi/Zgw8WmgwuN
         f9S28/LqicdjLiiIfRLyr3N156AoyUEUocRi0=
MIME-Version: 1.0
In-Reply-To: <EAD49B06-6234-42D7-803F-B764BC82AA3F@suse.de>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
	<4D9EBBC3.2040803@siemens.com>
	<1302251236.27918.31.camel@jaguar>
	<4D9ED146.7040004@siemens.com>
	<BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
	<4D9EE6A0.9020205@siemens.com>
	<EAD49B06-6234-42D7-803F-B764BC82AA3F@suse.de>
Date: Fri, 8 Apr 2011 16:33:15 +0400
Message-ID: <BANLkTimbngwN_D0+ML2AonCqZmMDMcB3eQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander Graf <agraf@suse.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "asias.hejun@gmail.com" <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 8, 2011, Alexander Graf <agraf@suse.de> wrote:
>
> On 08.04.2011, at 12:42, Jan Kiszka wrote:
>
>> On 2011-04-08 11:32, Cyrill Gorcunov wrote:
>>> It seems there is a misunderstanding. KVM-tool is quite far from been KVM
>>> replacement (if ever). And what we're doing -- extremely tiny/small HV which
>>> would help us to debug/test kernel code.
>>
>> I think your core team may have this vision, but my impression is that
>> some people here think much further.
>
> I tend to agree. The core team seems to write this as a helping aid of learning the platform and getting to know KVM. I really like that approach :).
>
> However, if it's meant to be a "toy" (and I don't mean this negatively in any way), it really should be declared as such. Calling it "kvm" for example would be a huge mistake in that case.
>
> Either way, I like the idea of having a second user space available for x86. Even if it just means that it verifies that the documentation is correct :).
>
>
> Alex
>
>

If we manage to make kvm-tool mature i believe anyone will win in such
case. The annonce stated clear the kvm-tool relation to qemu.

Of course we have great planes tho :)
