Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2DZD21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 23:28:27 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47267 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2DZD20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 23:28:26 -0400
Message-ID: <1335410904.2136.9.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Thu, 26 Apr 2012 13:28:24 +1000
In-Reply-To: <201204250012.00544.rjw@sisk.pl>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <201204232359.14109.rjw@sisk.pl>
	 <1335220840.2187.30.camel@shrek.rexursive.com>
	 <201204250012.00544.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 00:12 +0200, Rafael J. Wysocki wrote:
> Applied to linux-pm/linux-next.

Yeah, that was the wrong thing to do. The simpler patch I sent was for
stable only, as you requested.

This patch should go to linux-next:

http://marc.info/?l=linux-kernel&m=133426808115262&w=2

-- 
Bojan

