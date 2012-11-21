Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2KUHZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:25:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42806 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2KUHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:25:31 -0500
Date: Tue, 20 Nov 2012 23:25:28 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: EXYNOS: Add aliases for i2c controller for
 exynos4
Message-ID: <20121121072528.GJ7615@quad.lixom.net>
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353450428-2615-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:27:03PM -0800, Doug Anderson wrote:
> This is similar to a recent commit for exynos5250 titled:
>   ARM: EXYNOS: Add aliases for i2c controller
> 
> Adding aliases will be useful to prevent warnings in a future
> change.  See:
>   i2c: s3c2410: Get the i2c bus number from alias id
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>

This can go in independently of the pending comment on the i2c driver change
(that it should be done in the core, which makes sense).


-Olof
