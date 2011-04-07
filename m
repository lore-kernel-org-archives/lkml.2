Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1DGK05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:26:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752450Ab1DGK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:26:56 -0400
Date: Thu, 7 Apr 2011 11:26:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers, regulator: Remove unused variable 'wm831x'
Message-ID: <20110407102655.GA3138@opensource.wolfsonmicro.com>
References: <1302166854-9081-1-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302166854-9081-1-git-send-email-namei.unix@gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 05:00:54PM +0800, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> Variable ‘wm831x’ is not used in the function of
> wm831x_buckv_remove() and wm831x_buckp_remove().This
> patch removes 'em.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though I did send a patch for this it looks like it's been dropped
somewhere :/
