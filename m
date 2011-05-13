Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab1EMOJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:09:08 -0400
Received: from service87.mimecast.com ([94.185.240.25]:40909 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757221Ab1EMOJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:09:07 -0400
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= problem with kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: ttlxzz ccc <boyzccc@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	 <BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	 <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	 <009c01cc108b$4635c7d0$d2a15770$@com>
	 <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	 <BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	 <BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	 <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
	 <BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
	 <BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
Organization: ARM Limited
Date: Fri, 13 May 2011 15:08:57 +0100
Message-ID: <1305295737.31204.112.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 13 May 2011 14:09:02.0838 (UTC) FILETIME=[5007F160:01CC1177]
X-MC-Unique: 111051315090403301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 10:32 +0100, ttlxzz ccc wrote:
> I have tested kmemleak on the x86 and x86_64 architecture again. There
> is only
>  backtrace:
> 
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> unreferenced object 0xffffc90012d27000 (size 64):
> 
>  comm "insmod", pid 13092, jiffies 4298369684
> 
>  hex dump (first 32 bytes):
> 
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
>  backtrace:
> 
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> But in the x86, there is full backtrace.

Can you enable CONFIG_BACKTRACE_SELF_TEST and check whether the
boot-time backtrace test goes ok?

-- 
Catalin


