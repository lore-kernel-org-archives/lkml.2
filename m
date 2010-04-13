Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0DMLZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:25:35 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:39853 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331Ab0DMLZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:25:34 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 07:25:34 EDT
Message-ID: <4BC4529A.4010805@mimc.co.uk>
Date: Tue, 13 Apr 2010 12:16:42 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Can I limit the number of tcp connections ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way to limit the # tcp connections under Linux ?

I've tried ...

echo 8 > /proc/sys/net/core/somaxconn

... but I can still open 10 ssh sessions, as well as a web server.

I know I could run iptables, but I was looking for a much lower level
solution (with a smaller resource footprint).

Any clues ?

Thanks
Mark

