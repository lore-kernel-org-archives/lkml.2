Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0FUJAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:00:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50091 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753660Ab0FUJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:00:39 -0400
Subject: Re: [PATCH] drivers: regulators: depend on MFD_MAX8998
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1277107463-28153-1-git-send-email-m.szyprowski@samsung.com> (sfid-20100621_090439_366982_85F7EFA6)
Date: Mon, 21 Jun 2010 10:00:36 +0100
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Content-Transfer-Encoding: 7bit
Message-Id: <A00760BF-DCDB-4B34-8A8C-16C8A88C7347@opensource.wolfsonmicro.com>
References: <20100618003116.GA2761@opensource.wolfsonmicro.com> <1277107463-28153-1-git-send-email-m.szyprowski@samsung.com> (sfid-20100621_090439_366982_85F7EFA6)
To: Marek Szyprowski <m.szyprowski@samsung.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Jun 2010, at 09:04, Marek Szyprowski wrote:

> The MAX8998-pmic driver requires a core driver for all io operations. Like
> other regulator driver make it depend of the required MFD io driver.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

