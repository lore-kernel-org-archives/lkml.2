Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2IMU0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:26:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2IMU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:26:39 -0400
Date: Thu, 13 Sep 2012 22:26:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Stop perf stat -p when profiled process exits v3
Message-ID: <20120913202632.GY16230@one.firstfloor.org>
References: <1347551931-7666-1-git-send-email-andi@firstfloor.org> <505240BA.1010804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505240BA.1010804@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The is_alive function can be used by perf-top, perf-stat and perf-record 
> to know that its target has died so it can stop monitoring.
 
Sorry that's to complicated and overengineered for me.
My simple patch works for me at least. It's not solving world hunger,
but it wasn't intended to do that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
