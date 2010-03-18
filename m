Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0CRRMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:12:33 -0400
Received: from c60.cesmail.net ([216.154.195.49]:39501 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab0CRRMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:12:18 -0400
Subject: Re: [PATCH v2 7/7] wireless.h: Use SIOCIWFIRST not SIOCSIWCOMMIT
 for range check
From: Pavel Roskin <proski@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <b8a4d4b100a03c3f0d82eaeeb8a8e5f2efdd78d9.1268892664.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
	 <b8a4d4b100a03c3f0d82eaeeb8a8e5f2efdd78d9.1268892664.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 13:12:16 -0400
Message-Id: <1268932336.24544.6.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 23:21 -0700, Joe Perches wrote:
> These two #defines use the same value, but
> SIOCIWFIRST makes more sense in this use.

Agreed.  Also please change a comment referring to SIOCSIWCOMMIT in
include/net/iw_handler.h

It would be great if you don't copy LKML next time.  It's a purely
wireless issues.  I don't like having a dilemma between cross-posting
and trimming the recipient list.

-- 
Regards,
Pavel Roskin
