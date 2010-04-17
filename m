Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab0DQAX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 20:23:56 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:47006 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab0DQAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 20:23:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4BC8FF97.6040502@tremplin-utc.net>
Date: Sat, 17 Apr 2010 02:23:51 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>
CC: "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Change some config options to be automatically selected
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Here are two patches, which have for goal to simplify in Kconfig the
selection of the options WMI and BACKLIGHT_CLASS_DEVICE. Both are not
something that anyone will want per se, but only some kind of libraries
used by other modules. Some modules "selected" them while other just
"depended on" them, so to make things more consistent and easier to use,
always select those options.

I'm not sure if there is anyone who feels really the maintainer of the
platform-x86 directory, so probably it's for Andrew to get them in his
tree :-)

Cheers,
Eric
