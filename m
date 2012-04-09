Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2DIJlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 05:41:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56086 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2DIJlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:41:36 -0400
MIME-Version: 1.0
Date: Mon, 9 Apr 2012 15:11:35 +0530
Message-ID: <CA+h4rtET4-_0i8_49VbY_T_m+yyeUvEmsiJJRpeMmYWW+N6U=w@mail.gmail.com>
Subject: Regarding ipv6 route addition with tos
From: Ganesh Reddy K <ganeshreddyk@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Regarding ipv6 route addition along with tos argument on  Linux
2.6.34.6 kernel . And the iputility version which i  am using is :
Output of "ip -V" is   "ip utility, iproute2-ss110107"

I have added an ipv6 route as below. No error occurred  and when tried
to list the ipv6 route,  tos value is not displayed. Below are the
commands used. Did anybody encountered this issue ?

ip route add 2001:11::/64    dev   eth1    tos 12

ip -6 route show
  2001:11::/64   dev eth1   metric 1024   mtu     1500  advmss  1440
hoplilmit    0

Is the tos option applicable for IPV6 route ?   What is the correct
option to  set DSCP  value ?

Please share any bugfix or patch for this.

Thanks in advance,
Ganesh
