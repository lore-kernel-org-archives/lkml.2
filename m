Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2HCKmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 06:42:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32941 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab2HCKmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 06:42:10 -0400
Date: Fri, 3 Aug 2012 12:42:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kay Sievers <kay@vrfy.org>
Cc: "Pandita, Vikram" <vikram.pandita@ti.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
Message-ID: <20120803104212.GA6936@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kay Sievers <kay@vrfy.org>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Venu Byravarasu <vbyravarasu@nvidia.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mike Turquette <mturquette@linaro.org>,
	Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
 <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
 <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
 <CAFm5wm0nf47bcTu7iiXA3geR_5dDTF1tnf81Lz7JzbWkKdhUtA@mail.gmail.com>
 <CAPXgP11A=QfOt4SL2GvhsepP8JiDFfdaAhi6-AhW++-AvOz+aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPXgP11A=QfOt4SL2GvhsepP8JiDFfdaAhi6-AhW++-AvOz+aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 12:09:15PM +0200, Kay Sievers wrote:
> That would be needed, I guess. We easily have server systems with more
> than 255 CPUs. It will only be a matter of time, that the number of
> CPUs will increase for everybody, I guess.

Actually, AFAICR, we already have SGI machines booting Linux on 4K cpus. Now.

> > b) to put cpuid in struct cont and struct log - under the #ifdef macro?
> 
> As said, I really can't tell how generally useful it is, and if people
> think that it should be there unconditionally, should not be there at
> all, or as a compile time option. Others might have an opinion on
> that.
> 
> I personally never missed the CPU-ID in the logs. I personally would
> find the PID/task ID more interesting, and even that I never really
> missed. :)

And even then you can add debugging code to dump the stuff you need.

And I have to agree with Kai here, having the cpu number in dmesg is
not something I'd wish for - printk timestampts OTOH has at least some
usecases.

Thanks.

-- 
Regards/Gruss,
Boris.
