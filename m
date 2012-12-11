Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2LKDrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:47:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2LKDrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:47:13 -0500
Date: Tue, 11 Dec 2012 12:47:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, amit.kachhap@gmail.com,
        Thomas Abraham <thomas.abraham@linaro.org>, kgene.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: s5m8767: Fix to read the first DVS
 register.
Message-ID: <20121211034705.GC9097@opensource.wolfsonmicro.com>
References: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
 <1355143782-15133-3-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355143782-15133-3-git-send-email-amit.daniel@samsung.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 06:19:40PM +0530, Amit Daniel Kachhap wrote:
> This patch modifies the DVS register read function to select correct DVS1
> register. This change is required because the GPIO select pin is 000 in
> unintialized state and hence selects the DVS1 register.

Applied, thanks.
