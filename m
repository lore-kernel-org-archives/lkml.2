Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab2E0GVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 02:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2E0GVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 02:21:32 -0400
Date: Sun, 27 May 2012 09:21:29 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com,
        Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kvm: KVM internal error. Suberror: 1
Message-ID: <20120527062129.GK9769@redhat.com>
References: <1336324765.3638.4.camel@lappy>
 <4FA787D5.6040508@redhat.com>
 <CA+1xoqf7W1WsEvMHCEUZjBHJVUCaefnGo9qxu0pttCtoUURseg@mail.gmail.com>
 <CA+1xoqeha3EcYCy=sjER-9B0wn8wTdT-cUTwnvs7uN38uYFpmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqeha3EcYCy=sjER-9B0wn8wTdT-cUTwnvs7uN38uYFpmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 02:55:39AM +0200, Sasha Levin wrote:
> On Fri, May 11, 2012 at 1:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > I wasn't able to reproduce this issue so far.
> 
> So I've managed to hit this again, this time with a 3.4 host kernel:
> 
Do you have this instance of QEMU running?

> KVM internal error. Suberror: 1
> emulation failure
> RAX=0000000000000086 RBX=0000000000000086 RCX=0000000000000000
> RDX=ffff88000c860000
> RSI=0000000000000001 RDI=ffffffff811219d4 RBP=ffff88000d803d68
> RSP=ffff88000d803d50
> R8 =0000000000000000 R9 =0000000000000001 R10=0000000000000001
> R11=0000000000000001
> R12=ffff88000c8608f0 R13=0000000000000001 R14=ffffffff81116c80
> R15=0000000000000001
> RIP=ffffffff8197f940 RFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 0000000000000000 ffffffff 00000000
> CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
> SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0000 0000000000000000 ffffffff 00000000
> FS =0000 0000000000000000 ffffffff 00000000
> GS =0000 ffff88000d800000 ffffffff 00000000
> LDT=0000 0000000000000000 ffffffff 00000000
> TR =0040 ffff88000d9d3cc0 00002087 00008b00 DPL=0 TSS64-busy
> GDT=     ffff88000d804000 0000007f
> IDT=     ffffffff84e68000 00000fff
> CR0=8005003b CR2=00000000011f6000 CR3=000000003ca69000 CR4=000407f0
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000d01
> Code=04 e8 8e 5a 8a ff c9 c3 90 90 90 90 90 90 90 90 90 90 90 90 <55>
> 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 65 4c 8b 24
> 25 88 d9 00 00 65
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
