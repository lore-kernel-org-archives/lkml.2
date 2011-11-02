Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1KBJmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:42:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1KBJml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:42:41 -0400
Message-ID: <4EB1108F.6070009@gmail.com>
Date: Wed, 02 Nov 2011 11:42:39 +0200
From: =?ISO-8859-1?Q?Lars_Nood=E9n?= <lars.nooden@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hardware running hot and without the fan
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seem to be two problems here, one is that the hardware is getting
WAY too hot, another is that the fan is not turning on when the hardware
gets too hot.

  $ uname -a
  Linux xubuntu 3.1.0-999-generic #201110270406 SMP Thu Oct 27
  08:07:41 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

I've reported the problem to Ubuntu
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593
and the suggestion there was to report it upstream.

On the notebook computer, parts become very hot to the touch while
running Ubuntu, but the fan does not run even after it gets hot.  When I
boot back to OS X, the fan kicks in and runs until the computer returns
to being cool to the touch.  Similar for the desktop, though I must
follow the temperature with /usr/bin/sensors.

The notebook is a MacBookPro8,2 and the desktop is a Macmini3,1

What metrics do I need to collect to help fix the problem?  I've already
reported the problem to Ubuntu[2] and the recommendation was to try
reporting upstream.

Please CC me in the replies.
/Lars

[1] http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/

[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593
