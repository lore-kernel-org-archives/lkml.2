Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1LLHp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:45:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49924 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1LLHpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:45:54 -0500
Date: Sun, 11 Dec 2011 23:45:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: keyboard: Staticise non-exported symbols
Message-ID: <20111212074547.GC4682@core.coreip.homeip.net>
References: <1323394677.3740.2.camel@phoenix>
 <1323394752.3740.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323394752.3740.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 09:39:12AM +0800, Axel Lin wrote:
> These symbols are not used outside it's driver so no need to
> make the symbol global.
> 

Applied, thank you Axel.

-- 
Dmitry
