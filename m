Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2LXSrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:47:41 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:46178 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2LXSrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:47:40 -0500
Date: Mon, 24 Dec 2012 22:47:35 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: david <david@avoncliff.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resubmit  w1_therm:Retries:remove old code add CRC
Message-ID: <20121224184735.GA4143@ioremap.net>
References: <50CFC8F4.60601@avoncliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CFC8F4.60601@avoncliff.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for late reply - too much things to finish before the new year.

On Tue, Dec 18, 2012 at 01:37:56AM +0000, david (david@avoncliff.com) wrote:
> w1_therm includes some obsolete code to detect bad_roms, this is no
> longer relevant.
> The retry code is only used for this bad_rom test, however there is a
> CRC check that detects a bad read, but does not trigger a retry. This
> patch removes all the bad_rom code and uses the CRC check to trigger
> retries.
> 
> Signed-off-by: David Stevenson <david@avoncliff.com>

Greg, patch is ok, we discussed it in private with David
Please push it into your tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
