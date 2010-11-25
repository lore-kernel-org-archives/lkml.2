Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0KYRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:30:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44548 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0KYRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:30:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC/PATCH v6 02/12] media: Media device
Date: Thu, 25 Nov 2010 18:30:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
References: <1q7hf5w7lvslx3nba6ooh9j2.1290705631030@email.android.com>
In-Reply-To: <1q7hf5w7lvslx3nba6ooh9j2.1290705631030@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251830.40522.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Thursday 25 November 2010 18:20:31 Andy Walls wrote:
> The signedness of char is ambiguous for 8 bit data, which is why an API
> would normally use u8 (or s8, I guess).
> 
> Since this is known to be character data, I would think char would be fine.

I think so too.

> I am assuming C compilers would never assume multibyte "char"s.

Not on sane platforms I guess. We would have problems much worse than MC API 
breakage in that case anyway :-)

-- 
Regards,

Laurent Pinchart
