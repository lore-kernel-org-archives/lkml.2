Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0H3NO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:14:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38675 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0H3NOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g9Z2lGXA3Cv0EX8hHCJH3QjJUVSyAs0AKjEY/FSPmHvBBiqGO7jiDp8MI/LZStsdcf
         XzLUN9eQb0ROaWsbuLPKVWF3NbOpLFWU7w3n8mcTkysPmQE0d4XWaA0YV7iHi1wxsTak
         oL3jAwwzaVAg68Hw1Lg1CWcrPeg7NxOB2bnHo=
Subject: Re: [PATCH 3/7] drivers/mtd/nand/mpc5121_nfc.c: Add of_node_put to
 avoid memory leak
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1283075566-27441-4-git-send-email-julia@diku.dk>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
	 <1283075566-27441-4-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 16:13:40 +0300
Message-ID: <1283174020.12995.77.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-29 at 11:52 +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Pushed to l2-mtd-2.6.git / master, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

