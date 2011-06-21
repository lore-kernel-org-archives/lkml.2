Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1FUJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:10:22 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:52298 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1FUJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:10:19 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
Date: Tue, 21 Jun 2011 11:10:17 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211110.18171.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 June 2011 06:44:28 Tomoya MORINAGA wrote:
> Support interrupt function using irq_chip_generic
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

I wrote a small program which use poll(2) on value, after edge hase been 
configured from shell. I cannot test the edge detection appropriately due to 
debouncing using jumpers.

Despite from that:

Tested-by: Alexander Stein <alexander.stein@systec-electronic.com>
