Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1KQQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:51:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37158 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901Ab1KQQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:51:56 -0500
Date: Thu, 17 Nov 2011 16:51:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regmap: Drop check whether a register is readable
 in regcache_read
Message-ID: <20111117165153.GB9008@opensource.wolfsonmicro.com>
References: <1321472044-15686-1-git-send-email-lars@metafoo.de>
 <1321472044-15686-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321472044-15686-2-git-send-email-lars@metafoo.de>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 08:34:04PM +0100, Lars-Peter Clausen wrote:
> One of the reasons for using a cache is to have a software shadow of a register
> which is writable but not readable. This allows us to do a read-modify-write
> operation on such a register.

Applied, thanks.
