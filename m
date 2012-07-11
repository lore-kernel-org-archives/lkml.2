Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2GKNP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:15:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45150 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2GKNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXjX9CvoDoz7H46N=OAXUQrn5adWH3TQuWpQVTXRe7_-GVSBA@mail.gmail.com>
References: <CAGXjX9CvoDoz7H46N=OAXUQrn5adWH3TQuWpQVTXRe7_-GVSBA@mail.gmail.com>
Date: Wed, 11 Jul 2012 09:15:23 -0400
Message-ID: <CAGXjX9BU19E8etua+AqMPi3npXa8s1FUDNDaHq=qRTmAZ_6oxg@mail.gmail.com>
Subject: What's the TCP congestion control algorithm?
From: Martin Martin <martin@silverliningsystems.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the Wikipedia article on CUBIC, it's used in Linux kernels
2.6.19 and above.  Is that still the case?  Are there any plans to use a
different algorithm in the foreseeable future?

Is it as described in the 2008 ACM SIGOPS paper by Ha, Rhee and Xu:

http://cse.unl.edu/~xu/paper/ha_ACM_2008.pdf

?

Also, I'm having throughput problems when running netcat from machine A ->
machine B, then taking the output and using separate instances of netcat to
move it from B to C.  I'm guessing it's some interaction with the congestion
control algorithm, but I don't really know.  Can anyone suggest a more
appropriate mailing list, book or other resource for tracking this down?

Thanks,
Martin
