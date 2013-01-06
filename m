Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3AFWTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:19:23 -0500
Received: from jdl.com ([208.123.74.7]:41201 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3AFWTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:19:20 -0500
Message-Id: <E1Trxsl-0000Am-84@jdl.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: fdtdump: properly handle multi-string properties
In-reply-to: <1357326766-12691-1-git-send-email-panto@antoniou-consulting.com>
References: <1357326766-12691-1-git-send-email-panto@antoniou-consulting.com>
Comments: In-reply-to Pantelis Antoniou <panto@antoniou-consulting.com>
   message dated "Fri, 04 Jan 2013 21:12:46 +0200."
Date: Sun, 06 Jan 2013 15:35:51 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Device tree can store multiple strings in a single property.
> We didn't handle that case properly.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Applied.

Thanks,
jdl
