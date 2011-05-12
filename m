Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1ELPKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:10:30 -0400
Received: from service87.mimecast.com ([94.185.240.25]:55447 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751692Ab1ELPK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:10:29 -0400
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= problem with kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: ttlxzz ccc <boyzccc@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	 <BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	 <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	 <009c01cc108b$4635c7d0$d2a15770$@com>
	 <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	 <BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	 <BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	 <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
Organization: ARM Limited
Date: Thu, 12 May 2011 16:04:11 +0100
Message-ID: <1305212651.31204.60.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 12 May 2011 15:04:17.0520 (UTC) FILETIME=[DD528700:01CC10B5]
X-MC-Unique: 111051216042107501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 15:49 +0100, Américo Wang wrote:
> On Thu, May 12, 2011 at 10:33 PM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> > Thanks for Wangcong
> >
> > I have test the kmemleak-test.ko and the result includes no backtrace
> > except fffffffff, too.
> > I'm compling the kernel by make menuconfig. :)
> 
> Odd, this looks like a bug, Cc Catalin Marinas <catalin.marinas@arm.com>

Is STACKTRACE_SUPPORT enabled for this platform?

-- 
Catalin


