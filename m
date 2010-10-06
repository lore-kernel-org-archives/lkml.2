Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab0JFD4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:56:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54001 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756908Ab0JFD4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:56:06 -0400
Date: Tue, 5 Oct 2010 20:56:17 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: margie.foster@intel.com, Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Richard =?utf-8?Q?R=F6jfors?= <richard.rojfors@mocean-labs.com>,
        Alek Du <alek.du@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, meego-dev@meego.com
Subject: Re: [MeeGo-Dev][PATCH v4] Topcliff: Update PCH_GPIO driver to
 2.6.35
Message-ID: <20101006035616.GA30795@opensource.wolfsonmicro.com>
References: <4CABC02A.9060200@dsn.okisemi.com>
 <20101006003808.GA2464@opensource.wolfsonmicro.com>
 <000601cb6501$524d2030$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cb6501$524d2030$66f8800a@maildom.okisemi.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:50:58AM +0900, Masayuki Ohtake wrote:

> BTW, for adding to Linus's kernel tree, Do we need another action ? or
> Do we only just wait ?

The gpio tree is pretty much orphaned at the minute, I'd guess Andrew
Morton (who's already CCed) would be the most likely person to pick this
up since it's not a MFD device.
