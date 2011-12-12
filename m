Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1LLJsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:48:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50014 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1LLJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:48:35 -0500
Date: Mon, 12 Dec 2011 17:48:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20111212094827.GA31568@opensource.wolfsonmicro.com>
References: <1323422140-31332-1-git-send-email-dg77.kim@samsung.com>
 <1323422140-31332-2-git-send-email-dg77.kim@samsung.com>
 <20111209095855.GA1876@sirena.org.uk>
 <4EE5C330.8060902@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EE5C330.8060902@samsung.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 06:02:40PM +0900, Donggeun Kim wrote:
> On 2011년 12월 09일 18:58, Mark Brown wrote:
> > On Fri, Dec 09, 2011 at 06:15:39PM +0900, Donggeun Kim wrote:

> >> +	if (max77693_read_reg(i2c, MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {

> > I'd suggest also verifying that the ID register has the expected value.
> > If there's a chip reision register logging it can be helpful.

> The all expected values for the register are not specified at datasheet.
> The perpose of the read function is simply checking the existence of the
> device so that the following operations are stopped for error case.

With a name like "ID" it's clearly chip idenfication - you should at
least be displaying the value if it might change as it's likely to be
useful for diagnostics.
