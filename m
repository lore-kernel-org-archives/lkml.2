Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1E3C53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:57:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44666 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929Ab1E3C52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:57:28 -0400
Date: Mon, 30 May 2011 10:57:22 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] power: Fixed function return type
Message-ID: <20110530025720.GA4130@opensource.wolfsonmicro.com>
References: <1306693112-31609-1-git-send-email-kernel@kenobrien.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306693112-31609-1-git-send-email-kernel@kenobrien.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 07:18:32PM +0100, Ken O'Brien wrote:
> Applied coding convention to fix "WARNING: static const char * array should probably be static const char * const"
> 
> Signed-off-by: Ken O'Brien <kernel@kenobrien.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but note that your commit log doesn't describe the change (you're fixing
a data structure, not a function) and please word wrap within paragraphs
in your commit message for legibility.
