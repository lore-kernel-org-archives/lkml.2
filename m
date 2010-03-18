Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0CRRhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:37:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1827 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0CRRhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:37:03 -0400
Subject: Re: [PATCH v2 1/7] wireless.h: Add STD_IW_HANDLER macro
From: Joe Perches <joe@perches.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1268933005.24544.16.camel@mj>
References: <cover.1268892663.git.joe@perches.com>
	 <0475f4511eedbcca7fe4e8b7fb8a457aa81358dc.1268892664.git.joe@perches.com>
	 <1268933005.24544.16.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 10:37:00 -0700
Message-ID: <1268933820.2403.25.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 13:23 -0400, Pavel Roskin wrote:
> On Wed, 2010-03-17 at 23:21 -0700, Joe Perches wrote:
> > Copied from orinoco, initialize a iw_handler array entry
> > +#define STD_IW_HANDLER(id, func) \
> > +	[IW_IOCTL_IDX(id)] = (iw_handler) func
> Three objections.
> 1) STD_IW_HANDLER is a poor name for a header.  The name should start
> with IW, just like those above and below it.

Is IW_HANDLER ok with you?

> 3) Abstracting a cast is bad unless it's the whole purpose of the macro.
> While Orinoco needs the cast, other drivers may not need it.  Using a
> cast could prevent gcc from finding a legitimate problem.

I've no objection to moving the casts to the uses
of the macro where necessary.

