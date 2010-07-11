Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0GKJRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 05:17:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61019 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0GKJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 05:17:11 -0400
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org
Date: Sun, 11 Jul 2010 05:10:21 -0400
Subject: SNATed connections show as original ip in /proc/net/tcp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Noah McNallie" <n0ah@n0ah.org>
Message-ID: <op.vfn83jvflgimzx@win7>
User-Agent: Opera Mail/10.60 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just as the topic describes.

I'm currently doing SNAT to force some destination tcp ports to be routed  
through a specific route rather than the default route. To accomplish this  
I mark thoes packets with iptables, use 'ip' to specify marked packets via  
the specified route, and then use iptables to change their source address.

one problem i've noticed is that in netstat (and hence /proc/net/tcp) the  
connections are shown as their original source. this causes problems with  
some things such as identd, because identd won't see the SNATed to ip with  
that port open. hence it will reply that it has no connection.

anyway i can get around this?

noah
