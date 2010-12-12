Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0LLSlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:41:50 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:42257 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0LLSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:41:49 -0500
Date: Sun, 12 Dec 2010 12:41:45 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] load fbcon from drm_kms_helper
Message-ID: <20101212184145.GA13675@spacedout.fries.net>
References: <20101211210548.GK13567@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101211210548.GK13567@spacedout.fries.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 12 Dec 2010 12:41:45 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 03:05:48PM -0600, David Fries wrote:
> +	const char *namue = "fbcon";
Typo, 'namue' see the next patch.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
