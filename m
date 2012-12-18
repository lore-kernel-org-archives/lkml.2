Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2LRBUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:20:22 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:15123 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2LRBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:19:47 -0500
Message-ID: <50CFC4B0.4010905@tilera.com>
Date: Mon, 17 Dec 2012 20:19:44 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] arch/tile: implement user_regset interface on
 tile
References: <1355792891-16145-1-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1355792891-16145-1-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 8:08 PM, Simon Marchi wrote:
> This is a basic implementation of user_regset for the tile
> architecture. It reuses the basic blocks that were already there.
>
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>

Thanks, I'll take this into the tile tree for this merge window.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

