Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1LLEEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:04:54 -0500
Received: from lo.gmane.org ([80.91.229.12]:53004 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab1LLEEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:04:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/4] PM / Sleep: Make =?utf-8?b?cG1fb3AoKQ==?= and =?utf-8?b?cG1fbm9pcnFfb3AoKQ==?= return callback pointers
Date: Mon, 12 Dec 2011 04:04:39 +0000 (UTC)
Message-ID: <loom.20111212T041314-709@post.gmane.org>
References: <201112100018.38536.rjw@sisk.pl> <201112100020.00368.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 121.50.20.41 (Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20100101 Firefox/8.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw <at> sisk.pl> writes:

> 
> From: Rafael J. Wysocki <rjw <at> sisk.pl>
> 
> Make the pm_op() and pm_noirq_op() functions return pointers to
> appropriate callbacks instead of executing those callbacks and
> returning their results.
> 
> This change is required for a subsequent modification that will
> execute the corresponding driver callback if the subsystem
> callback returned by either pm_op(), or pm_noirq_op() is NULL.
> 

Hello Rafael,

How about typedef'ing something like pm_callback_t for readability?

   typedef int (*pm_callback_t)(struct device *);

This way, the code will be easier to read.
(Dropped inline changes below due to the grumpiness of the GMANE's
web interface)

Thanks.
Namhyung Kim


