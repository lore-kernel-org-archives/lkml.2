Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0CRRHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:07:43 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:45161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0CRRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:07:41 -0400
Subject: Re: [PATCH v2 0/7] wireless: Use macros from wireless.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Geoff Levand <geoffrey.levand@am.sony.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pavel Roskin <proski@gnu.org>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       Corey Thomas <coreythomas@charter.net>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net
In-Reply-To: <cover.1268892663.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 09:21:53 -0700
Message-ID: <1268929313.4005.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 23:21 -0700, Joe Perches wrote:
> Move the STD_IW_HANDLER macro from orinoco to wireless.h
> Use the wireless.h macros in various wireless files
> Remove local #defines of IW_IOCTL

I really don't want to debug any breakage here, but otherwise I don't
care and this is fine with me.

johannes

