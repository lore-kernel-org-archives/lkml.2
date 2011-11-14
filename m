Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1KNOF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:05:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1KNOF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:05:57 -0500
Date: Mon, 14 Nov 2011 15:07:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111114140714.GD2513@redhat.com>
References: <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
 <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
 <20111110114732.GA2217@redhat.com>
 <20111110125347.GA29415@nomi.cz>
 <20111110160703.GA2775@redhat.com>
 <20111110163051.GA24533@nomi.cz>
 <20111111054731.GA2292@redhat.com>
 <20111111150105.GA25437@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111111150105.GA25437@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 11, 2011 at 04:01:05PM +0100, Tomáš Janoušek wrote:
> Could you please elaborate on that thing with enabling IOMMU? The only thing I
> know about IOMMU is that it is somehow related to VT-d (passing whole PCI
> devices to virtual guests), and that I have to pass intel_iommu=off to kernel
> command line, otherwise the machine doesn't even boot. Is that a problem?
Yes. That mean iommu software or hardware is broken on your system.

I have no other ideas how to track this down. I think now, this is
a firwmare issue. BTW, you suspected that from very beginning :-)
This could be also a driver issue, but AFAICT programing DMA do not
differ on 6205 from other devices, so bug in firmware is much more
probable reason of corruption.

Stanislaw
