Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1KKPBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:01:13 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:54165 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab1KKPBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:01:09 -0500
Date: Fri, 11 Nov 2011 16:01:05 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111111150105.GA25437@nomi.cz>
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz> <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz> <20111111054731.GA2292@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111111054731.GA2292@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 11, 2011 at 06:47:31AM +0100, Stanislaw Gruszka wrote:
> On Thu, Nov 10, 2011 at 05:30:51PM +0100, Tomáš Janoušek wrote:
> > I think all those T520 and T420s models have exactly the same wireless card. I
> > don't see why they wouldn't have. :-)
>
> Well, laptops models have common mainboards, but peripheral components
> might not be identical. Especially wireless card might vary from unit
> to unit. For example:
> 
> T520 with iwl6300:
> http://smolt.fedoraproject.org/client/show/pub_0cbc8731-47d3-4ecf-8add-aa832b34edcd
> T520 with iwl1000:
> http://smolt.fedoraproject.org/client/show/pub_02f601d6-7a93-4c0e-bc01-a4a95db36086 
> T520 with iwl6205:
> http://smolt.fedoraproject.org/client/show/pub_0232252f-75a9-4050-a69b-c8e95e00eaf2

These links don't work, but my colleagues indeed do have iwl6205. They are,
however, running 64-bit kernels, so I tried doing the same and I haven't been
able to reproduce the issue for the past few hours. So it seems like it
happens on 32-bit kernels only. This looks like a good workaround (better than
getting a different wireless card), so I can run 64-bit during working days
and experiment with 32-bit when I have time to debug this.

Could you please elaborate on that thing with enabling IOMMU? The only thing I
know about IOMMU is that it is somehow related to VT-d (passing whole PCI
devices to virtual guests), and that I have to pass intel_iommu=off to kernel
command line, otherwise the machine doesn't even boot. Is that a problem?

Kind regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
