Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2D0A0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:26:12 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:51022 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2D0A0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:26:10 -0400
Message-ID: <1335486369.2136.24.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Fri, 27 Apr 2012 10:26:09 +1000
In-Reply-To: <1335485772.2136.21.camel@shrek.rexursive.com>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <201204262200.32663.rjw@sisk.pl>
	 <1335474828.2136.15.camel@shrek.rexursive.com>
	 <201204270011.20430.rjw@sisk.pl>
	 <1335485772.2136.21.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 10:16 +1000, Bojan Smojver wrote:
> Here it is.

So, a quick summary:

These patches should go to linux-pm/linux-next (in that order):

http://marc.info/?l=linux-kernel&m=133522096505280&w=2
http://marc.info/?l=linux-kernel&m=133548592706940&w=2

Only this patch should to to -stable:

http://marc.info/?l=linux-kernel&m=133522096505280&w=2

-- 
Bojan

