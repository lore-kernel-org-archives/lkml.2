Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3AFWTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:19:15 -0500
Received: from jdl.com ([208.123.74.7]:50049 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3AFWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:19:13 -0500
Message-Id: <E1Trxva-0000Co-25@jdl.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix util_is_printable_string
In-reply-to: <1357326778-12725-1-git-send-email-panto@antoniou-consulting.com>
References: <1357326778-12725-1-git-send-email-panto@antoniou-consulting.com>
Comments: In-reply-to Pantelis Antoniou <panto@antoniou-consulting.com>
   message dated "Fri, 04 Jan 2013 21:12:58 +0200."
Date: Sun, 06 Jan 2013 15:38:46 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: 0.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The method used did not account for multi-part strings.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>


Applied.

Plese consider a follow-up patch to address David's concerns.

Thanks,
jdl
