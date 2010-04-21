Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0DURmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:42:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33872 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753978Ab0DURmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:42:24 -0400
Date: Thu, 22 Apr 2010 02:42:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin Vincent <rabin@rab.in>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: WM8350: remove incorrect kfree
Message-ID: <20100421174227.GB19576@opensource.wolfsonmicro.com>
References: <1271864165-8096-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271864165-8096-1-git-send-email-rabin@rab.in>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:06:05PM +0530, Rabin Vincent wrote:
> The i2c_client received in probe() should not be kfree()'d.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
