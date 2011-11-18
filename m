Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1KREJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:09:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50117 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1KREJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:09:27 -0500
MIME-Version: 1.0
Date: Fri, 18 Nov 2011 12:09:25 +0800
Message-ID: <CABPbr_msepemFt4ezGVRk3QS0MU3F47MKimfV4Y+6jqvUrLFeA@mail.gmail.com>
Subject: ipv4 udplite broken in >=linux-3.0 ?
From: Jinxin Zheng <jinxinzheng@gmail.com>
To: gerrit@erg.abdn.ac.uk
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently migrated my work from udp to udplite. Thanks for your great effort.

But after I upgraded the kernel from 2.6.38 to 3.0, the ipv4 version
of udplite stops working.
I tested the applications downloaded from Gerrit's udplite wiki, and
found that the ipv6 version works well, but not ipv4.

I did the tests on a Gentoo. The kernels are downloaded from the
official web site.

I don't know how to debug udplite. Can any one of you give me a tip on
how to get more debug info, then I can do further test and provide
with it?

Thanks!

--
Zheng Jinxin
