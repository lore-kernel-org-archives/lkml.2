Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1ABMhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:37:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48197 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752521Ab1ABMhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:37:31 -0500
Date: Sun, 2 Jan 2011 12:37:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: missing index in PTR_ERR() in
 isl6271a_probe()
Message-ID: <20110102123747.GA4935@opensource.wolfsonmicro.com>
References: <4D1DF637.1060609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1DF637.1060609@gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 04:26:47PM +0100, roel kluin wrote:
> The index is missing so the return is wrong.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
