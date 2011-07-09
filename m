Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1GIWsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 18:48:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41080
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab1GIWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 18:48:05 -0400
Date: Sat, 9 Jul 2011 18:48:03 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Rik van Riel <riel@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.0-rc6 ~9X system time degradation on kernbench
Message-ID: <20110709224803.GC9545@bombadil.infradead.org>
References: <4E175C45.1060700@redhat.com>
 <4E17A4BF.5050500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E17A4BF.5050500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 08:45:51PM -0400, Rik van Riel wrote:
> On 07/08/2011 03:36 PM, Prarit Bhargava wrote:
> >Just some numbers out of kernbench.  System Time&  Context Switches
> >climb dramatically between 2.6.38 and 3.0.0-rc6.  Currently bisecting to
> >find out why.  .config is based on Fedora's x86_64 .config.
> 

Er, if you're using Fedora's config, did you 'make release' first?
grep DEBUG in the config and see why... ;-)

> For the record, I am also seeing dramatically increased
> CPU use with the 3.0-rc kernel, vs 2.6.38.
> 
> I first attributed it to me upgrading my video card, but
> Prarit is seeing slowdowns too, so it's not just me...
> 
> -- 
> All rights reversed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
