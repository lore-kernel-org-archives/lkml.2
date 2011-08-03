Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1HCEjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:39:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45006 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752954Ab1HCEi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:38:58 -0400
Date: Wed, 3 Aug 2011 13:38:49 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8952: removed unused mutex.
Message-ID: <20110803043847.GA15341@opensource.wolfsonmicro.com>
References: <4E37FE95.7090808@ti.com>
 <1312333083-22615-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312333083-22615-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 09:58:03AM +0900, MyungJoo Ham wrote:
> This patch removes a mutex that is never used in the driver.
> 
> Reported-by: Axel Lin
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
