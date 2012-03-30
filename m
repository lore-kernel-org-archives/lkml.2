Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662Ab2C3UpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:45:15 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36381 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127Ab2C3UpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:45:13 -0400
Message-ID: <1333140310.2058.16.camel@shrek.rexursive.com>
Subject: Re: [PATCH v7]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Sat, 31 Mar 2012 07:45:10 +1100
In-Reply-To: <201203302137.37731.rjw@sisk.pl>
References: <1332891672.2040.24.camel@shrek.rexursive.com>
	 <201203282329.11086.rjw@sisk.pl>
	 <1333071789.2058.2.camel@shrek.rexursive.com>
	 <201203302137.37731.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 21:37 +0200, Rafael J. Wysocki wrote:
> Still, if it is a regression fix

That is my suspicion, yes. I am waiting on feedback about the patch,
related to a bug report where hibernation hangs with 3.2 (but not
earlier). The cause of this bug seems to be kernel running out of pages,
because hibernation code took a smidgen too much.

-- 
Bojan

