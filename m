Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0JFAh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:37:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754866Ab0JFAh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:37:57 -0400
Date: Tue, 5 Oct 2010 17:38:09 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, margie.foster@intel.com
Subject: Re: [MeeGo-Dev][PATCH v4] Topcliff: Update PCH_GPIO driver to
 2.6.35
Message-ID: <20101006003808.GA2464@opensource.wolfsonmicro.com>
References: <4CABC02A.9060200@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CABC02A.9060200@dsn.okisemi.com>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:17:46AM +0900, Masayuki Ohtak wrote:

> GPIO driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has GPIO I/F. Using this I/F, it is able to access system
> devices connected to GPIO.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
