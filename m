Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2AVDsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:48:03 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:55059 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2AVDsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:48:01 -0500
Date: Sat, 21 Jan 2012 20:47:59 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
cc: =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>
Subject: Re: [PATCH 6/8] ARM: OMAP4: hwmod data: add HDQ/1-wire hwmod
In-Reply-To: <20120121235934.17619.74939.stgit@dusk>
Message-ID: <alpine.DEB.2.00.1201212046380.26641@utopia.booyaka.com>
References: <20120121235333.17619.56725.stgit@dusk> <20120121235934.17619.74939.stgit@dusk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, 21 Jan 2012, Paul Walmsley wrote:

> Add the hwmod data for the HDQ/1-wire hwmod ('hdq1w').  The scripts have 
> been updated.

just a quick note, I've dropped this patch from the series.  The HDQ 
driver does byte-width accesses, which breaks pretty badly on OMAP4.  A 
patch to fix this will be sent separately, and once that is merged, we'll 
deal with adding the OMAP4 data.


- Paul
