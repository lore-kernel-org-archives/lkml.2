Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab2LHOzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:55:09 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42874
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab2LHOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:55:08 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kys@microsoft.com
Subject: mm 
Date: Sat,  8 Dec 2012 07:18:49 -0800
Message-Id: <1354979929-18462-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running some compilation load on a Linux-next kernel of December 2,
2012, I see the following messages:

[ 1164.988521] BUG: Bad rss-counter state mm:ffff88002f8aa740 idx:1 val:-2
[ 5042.442664] BUG: Bad rss-counter state mm:ffff88002f029140 idx:1 val:-1
[ 5046.108841] BUG: Bad rss-counter state mm:ffff88000d052040 idx:1 val:-1
[ 7534.904609] BUG: Bad rss-counter state mm:ffff88002faf9740 idx:1 val:-1

Regards,

K. Y
