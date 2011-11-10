Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966Ab1KJOdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:33:42 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53568 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934935Ab1KJOdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:33:41 -0500
Date: Thu, 10 Nov 2011 23:33:33 +0900
From: =?utf-8?B?SsOpcsO0bWU=?= Pinot <ngc891@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Evolution of kernel size
Message-ID: <20111110143333.GA29457@comet.deepsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I took some time to make a graph of the evolution of the size of the
linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
It doesn't count the stable branches (2.6.x.y).

Impressive, it's mostly exponential.
If dev keeps same pace, we should break the 100MB at
linux 3.19.

You can get the graph on my blog, I provide the data and the
gnuplot batch file for graphing/fitting:
http://ngc891.blogdns.net/?p=92 

It may interest some people :-)

-- 
Jérôme Pinot
http://ngc891.blogdns.net/
