Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2BPVIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:08:09 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43052 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2BPVIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:08:07 -0500
Date: Thu, 16 Feb 2012 23:08:05 +0200 (EET)
From: mroos@linux.ee
To: Grant Likely <grant.likely@secretlab.ca>
cc: David Miller <davem@davemloft.net>, rob.herring@calxeda.com,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <CACxGe6tqsYs8-n2Q+EGGekS6wOOYYXUvUbEu6sfQ7U3--Gyjnw@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1202162307250.19246@math.ut.ee>
References: <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <20120213.195835.1573147101037168145.davem@davemloft.net>
 <CACxGe6tqsYs8-n2Q+EGGekS6wOOYYXUvUbEu6sfQ7U3--Gyjnw@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Definitely not right!  It would be interesting to add a printk() to
> of_find_node_by_phandle() or of_find_node_by_path() to blast out the
> node names as it traverses the tree.  That could help track down
> corruption.

[    0.000000] of_find_node_by_path: /chosen
[    0.000000] of_find_node_by_path: /aliases                      ¥_6䥷~ê7\eý+õï*¢ꢏñ?¿sM       ý{
aliases000000] ò7find_node_by_path: ðÑÔ_Bÿ
[    0.000000] Unable to handle kernel NULL pointer dereference

-- 
Meelis Roos (mroos@linux.ee)
