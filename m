Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2DTJZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:25:23 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64110 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DTJZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:25:21 -0400
Date: Fri, 20 Apr 2012 17:25:25 +0800
From: Wang YanQing <udknight@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Subject: [RFC]Is usb port number fixed?
Message-ID: <20120420092525.GA12660@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
when I execute the command below:

"ls /sys/bus/usb/devices/"

I get:
"1-0:1.0 1-1 1-1:1.0 2-0:1.0 2-1 2-1.1 2-1:1.0 2-1.1:1.0 2-1.5 2-1.5:1.0 2-1.5:1.1  usb1  usb2"

the output format is bus-port.port:config.interface
I want to know whether the port number is fixed after I reboot machine time by time.
And if it is fixed, then what make it.

Thanks!
