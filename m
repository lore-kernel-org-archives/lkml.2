Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0IAStl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:49:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab0IAStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:49:40 -0400
Subject: Re: [alsa-devel] [PATCH 2/4] sound/soc/fsl/p1022_ds.c: Add
 of_node_put to avoid memory leak
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Julia Lawall <julia@diku.dk>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <AANLkTinpRVStYfHHaGTyLusMCjMQDH=MvcGVVKaxvHtN@mail.gmail.com>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
	 <1283269738-14612-3-git-send-email-julia@diku.dk>
	 <AANLkTinpRVStYfHHaGTyLusMCjMQDH=MvcGVVKaxvHtN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 19:49:36 +0100
Message-ID: <1283366976.3081.248.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 13:39 -0500, Timur Tabi wrote:
> On Tue, Aug 31, 2010 at 10:48 AM, Julia Lawall <julia@diku.dk> wrote:
> > Add a call to of_node_put in the error handling code following a call to
> > of_parse_phandle.
> >
> > This patch also moves the existing call to of_node_put tothe end of the
> > error handling code, to make it possible to jump to of_node_put without
> > doing the other cleanup operations.  These appear to be disjoint
> > operations, so the ordering doesn't matter.
> 
> Acked-by: Timur Tabi <timur@freescale.com>

Acked-by: Liam Girdwood <lrg@slimlogic.uo.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

