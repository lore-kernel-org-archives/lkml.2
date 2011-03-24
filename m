Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab1CXIb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:31:29 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:29495 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933710Ab1CXIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:31:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH+cik1R8iFe/2dsb2JhbAClQniITbk9DYVcBA
Date: Thu, 24 Mar 2011 09:31:20 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Waychison <mikew@google.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org, Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH -v3 -resend] watchdog, SP5100: Check if firmware has
	set correct value in tcobase.
Message-ID: <20110324083120.GC4968@infomag.iguana.be>
References: <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop> <alpine.DEB.2.00.1103161442210.3382@kaball-desktop> <4D80F992.10603@kernel.org> <alpine.DEB.2.00.1103161757040.3382@kaball-desktop> <4D812180.5030102@kernel.org> <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com> <4D812919.30706@kernel.org> <20110317022331.GA3528@dumpdata.com> <4D8AD791.9010602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8AD791.9010602@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

> Stefano found SP5100 TCO watchdog driver using wrong address.
>
> [    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
> [    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1
>
> and e820 said that range is RAM.
>
> We should check if we can use that reading out. BIOS could just program wrong address there.
>
> -v2: Mike pointed out one path need one release.
> -v3: corrected logic checking with request_mem_region_exclusive()
>      Found by Konrad.
>
>
> Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by:Yinghai Lu <yinghai@kernel.org>
> Acked-by: Mike Waychison <mikew@google.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

This patch is in linux-2.6-watchdog-next for a week now. Will go upstream to linus.

Kind regards,
Wim.

