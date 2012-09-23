Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2IWWwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 18:52:50 -0400
Received: from smtp.getmail.no ([84.208.15.66]:35786 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab2IWWwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 18:52:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Mon, 24 Sep 2012 00:52:46 +0200
Subject: Re: Linux 3.6-rc6
To: linux-kernel@vger.kernel.org
From: Notifications <notifications@paradoxuncreated.com>
Message-id: <op.wk31t8144557yb@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works fine on my (localized) desktop, except with bootparameter  
"threadirqs" which has not been working since it was introduced.
Jitterlevels are very low now, regular os-jitter is typically below 1 ms.  
(with a low jitter config) Which means audioapps run 1 ms latency, without  
rt-threads, and opengl is very smooth.
I would really love to get that down to 250uS though, after which I don`t  
care.

I also did the low-jitter config on the latest ubuntu-kernel, and wrote a  
little bit about it here.  
http://paradoxuncreated.com/Blog/wordpress/?p=2268

Paece Be With You.
