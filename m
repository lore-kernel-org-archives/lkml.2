Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0FHIiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:38:21 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24717 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0FHIiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:38:20 -0400
Subject: Re: OMAP video compile error; regression from 2.6.33-rc4 onward
 (including current master)
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Luke-Jr <luke@dashjr.org>
Cc: "slapin@ossfans.org" <slapin@ossfans.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <201006071117.22645.luke@dashjr.org>
References: <201006061652.39248.luke@dashjr.org>
	 <1275896854.2549.14.camel@tubuntu.research.nokia.com>
	 <201006071117.22645.luke@dashjr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 11:36:52 +0300
Message-ID: <1275986212.2549.41.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 08:37:21.0709 (UTC) FILETIME=[CFFF65D0:01CB06E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 18:17 +0200, ext Luke-Jr wrote:
> On Monday 07 June 2010 02:47:34 am Tomi Valkeinen wrote:
> > I don't have any device that uses RFBI so I can't test it, but how about
> > this patch:
> 
> Unfortunately, I can't test it either since N8x0 has no mainline support for 
> video output, nor can until CBus is merged. :(

Okay. I'll put it in, then, as it at least compiles.

 Tomi


