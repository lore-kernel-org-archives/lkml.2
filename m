Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1KTCUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 21:20:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:45429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab1KTCUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 21:20:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,540,1315206000"; 
   d="scan'208";a="87378460"
Subject: Re: iwlagn: memory corruption with WPA enterprise
From: wwguy <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111119181106.GA5515@nomi.cz>
References: <20111109155411.GA1669@nomi.cz>
	 <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz>
	 <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz>
	 <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz>
	 <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz>
	 <20111114140714.GD2513@redhat.com>  <20111119181106.GA5515@nomi.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 18:13:53 -0800
Message-ID: <1321755233.22510.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 10:11 -0800, Tomáš Janoušek wrote:
> Hello,
> 
> On Mon, Nov 14, 2011 at 03:07:15PM +0100, Stanislaw Gruszka wrote:
> > On Fri, Nov 11, 2011 at 04:01:05PM +0100, Tomáš Janoušek wrote:
> > > Could you please elaborate on that thing with enabling IOMMU? The only thing I
> > > know about IOMMU is that it is somehow related to VT-d (passing whole PCI
> > > devices to virtual guests), and that I have to pass intel_iommu=off to kernel
> > > command line, otherwise the machine doesn't even boot. Is that a problem?
> > Yes. That mean iommu software or hardware is broken on your system.
> >
> > I have no other ideas how to track this down. I think now, this is
> > a firwmare issue. BTW, you suspected that from very beginning :-)
> > This could be also a driver issue, but AFAICT programing DMA do not
> > differ on 6205 from other devices, so bug in firmware is much more
> > probable reason of corruption.
> 
> I have some news. I got IOMMU to work, because I identified the problem [1]
> and disabled firewire-ohci for the time being completely, but I'm not sure
> what do I need to do to make it catch the problem. I assumed that all I need
> is to intel_iommu=on and then all devices do DMA stuff in isolation, but I can
> still reproduce the issue without the smallest hint of an error in dmesg. Does
> it tell us anything, or shall I enable some more debugging stuff?
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.pci/8765/focus=1217800
> 
> Anyway, I didn't get to trying 2.6.38/39 yet, but I will do that soon. It is
> also safe to say now that x86_64 is completely unaffected, as I was running
> various 64bit kernels the whole week without a single failure.
> 


hmm, I don't have any IOMMU supported system, I guess it is the time to
get one :-)

Wey



