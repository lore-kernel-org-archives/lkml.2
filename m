Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0FVBGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:06:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46064 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0FVBGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:06:07 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Date: Tue, 22 Jun 2010 09:05:56 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-arm-kernel@lists.infradead.org
References: <1277098513.947920.264679354891.2.gpush@pororo> <4C1FCEDA.3000303@bluewatersys.com>
In-Reply-To: <4C1FCEDA.3000303@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006220905.57533.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> Not sure if this has been discussed already, but shouldn't rate be const
> for a fixed clock?

No, we may need to set the rate at some point - eg, when setting up the 
clocks, or parsing from the device tree.

Cheers,


Jeremy
