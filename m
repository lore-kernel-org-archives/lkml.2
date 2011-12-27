Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1L0K4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:56:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44921 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab1L0K4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:56:00 -0500
Date: Tue, 27 Dec 2011 10:55:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, cbouatmailru@gmail.com, pali.rohar@gmail.com,
        prakity@mavell.com, lars@metafoo.de, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] power: introduce Charger-Manager
Message-ID: <20111227105555.GG2870@opensource.wolfsonmicro.com>
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:47:47PM +0900, Donggeun Kim wrote:

> Changes for v3:
>     - rename variables and functions
>     - clean up code
>     - add build dependency of RTC_CLASS and REGULATOR

Does it actually depend on REGULATOR?  It looks like it just uses get
and enable which are stubbed out automatically by the API.
