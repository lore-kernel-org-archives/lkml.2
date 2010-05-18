Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0ERXFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:05:05 -0400
Received: from lucidpixels.com ([75.144.35.66]:35475 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0ERXFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:05:03 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 19:05:03 EDT
Date: Tue, 18 May 2010 18:58:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.34 kernel: UDP short packet
Message-ID: <alpine.DEB.2.00.1005181857110.17535@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With 2.6.33, I do not recall seeing these messages:
[90566.549202] UDP: short packet: From src:53 2048/8 to my_dst_ip:53
[90569.545921] net_ratelimit: 21 callbacks suppressed

With 2.6.34, there is an addition to capture these events?

Justin.

