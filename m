Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1HSQvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:51:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40602 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab1HSQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:51:47 -0400
Date: Fri, 19 Aug 2011 20:51:43 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Philip Rakity <prakity@marvell.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Subject: Re: [PATCH] power: max17042: bugfix of incorrect voltage register
 value interpretation.
Message-ID: <20110819165143.GJ22761@oksana.dev.rtsoft.ru>
References: <1313543914-19992-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313543914-19992-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:18:34AM +0900, MyungJoo Ham wrote:
> The calculation had error in getting voltage values from
> MAX17042 registers. The least bit denotes 78.125uV (625/8).
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thank you.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
