Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1DOTKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:10:50 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:58780 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751127Ab1DOTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:10:47 -0400
Date: Fri, 15 Apr 2011 21:02:13 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
Message-ID: <20110415190213.GA3981@game.jcrosoft.org>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
 <20110413225818.39ce5104@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413225818.39ce5104@bob.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10967390993979059140
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:58 Wed 13 Apr     , Alan Cox wrote:
> On Wed, 13 Apr 2011 21:47:18 +0200
> Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> 
> > specify the port num via platform_data this will allow to match the
> > clock with the plaform_dev staticly
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD
> > <plagnioj@jcrosoft.com> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
> > Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > Cc: Alan Cox <alan@linux.intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Ack for the serial side, its really an arch patch though as far as I
> can see..
applied in at91-l2

Best Regards,
J.
