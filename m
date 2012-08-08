Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528Ab2HHR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:57:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55776 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2HHR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:57:54 -0400
Message-ID: <5022A89F.8070604@wwwdotorg.org>
Date: Wed, 08 Aug 2012 11:57:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, w.sang@pengutronix.de
CC: olof@lixom.net, khali@linux-fr.org, ben-linux@fluff.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 0/4] i2c: tegra: required clock support for controller
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 01:51 AM, Laxman Dewangan wrote:
> The Tegra's i2c controller required two clock sources for proper
> operation named as div-clk and fast-clk.
> 
> Adding support to make sure that driver will get these clocks and 
> enable before any transfer and disable after transfer completed.

This works fine on Cardhu and Ventana for me. I'll apply it once I get
an ack from Wolfram to take the I2C driver patch through the Tegra tree.
