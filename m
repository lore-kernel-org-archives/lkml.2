Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1L1LGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 06:06:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48645 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569Ab1L1LF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 06:05:57 -0500
Date: Wed, 28 Dec 2011 11:05:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, cbouatmailru@gmail.com, pali.rohar@gmail.com,
        prakity@mavell.com, lars@metafoo.de, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] power: introduce Charger-Manager
Message-ID: <20111228110550.GB24405@opensource.wolfsonmicro.com>
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
 <20111227105555.GG2870@opensource.wolfsonmicro.com>
 <4EFA9F90.8090204@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EFA9F90.8090204@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 01:48:16PM +0900, Donggeun Kim wrote:
> On 2011년 12월 27일 19:55, Mark Brown wrote:

> > Does it actually depend on REGULATOR?  It looks like it just uses get
> > and enable which are stubbed out automatically by the API.

> If CONFIG_REGULATOR is not defined,
> compile error occurs because charger-manager calls
> 'regulator_force_disable' function.

That seems like what we should fix, not adding the dependency.
