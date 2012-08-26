Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2HZHxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 03:53:33 -0400
Received: from dell.nexicom.net ([216.168.96.13]:40012 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab2HZHxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 03:53:32 -0400
Message-ID: <50399D1A.9080000@lockie.ca>
Date: Sat, 25 Aug 2012 23:50:50 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120719 Thunderbird/14.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ifdef only module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to only run code if a module is being built.

drivers/media/video/cx25840/cx25840-core.c: 394
If it is built into kernel it causes a timeout because it relies on udev which is not initialized yet.
The code is only needed to provide analog reception.
