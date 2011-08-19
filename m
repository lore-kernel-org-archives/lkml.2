Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1HSMXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:23:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43936 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1HSMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:23:14 -0400
MIME-Version: 1.0
Date: Fri, 19 Aug 2011 21:23:13 +0900
Message-ID: <CAK7N6vrj8V+7EYLmd92qd+Mae2KZu8K6BVwnwda=3y2vrcDWRw@mail.gmail.com>
Subject: Headset driver detection problem during bootup
From: anish singh <anish198519851985@gmail.com>
To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Kernel-newbies <kernelnewbies@nl.linux.org>
Cc: broonie@opensource.wolfsonmicro.com, Jonathan Cameron <jic23@cam.ac.uk>,
        Dave Hylands <dhylands@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need some suggestions for below situation:

Headset if it is inserted before the device is powered up is
now detected by forcefully calling the interrupt handler in
the probe function of the headset driver.
Once the handler is called then we find out if the headset
is there or not using gpio and then normal detection happens

Is it the right way to detect the device during power-up?

After the device is powered up and then if we insert headset
then it is working fine by calling the interrupt handler and
everything goes fine.

linux -2.3.5
Android Device
