Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1KENyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 09:54:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58070 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KENyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 09:54:39 -0400
Message-ID: <4EB5401B.4080708@gmail.com>
Date: Sat, 05 Nov 2011 14:54:35 +0100
From: Carla Sella <carla.sella@gmail.com>
Reply-To: carla.sella@gmail.com
Organization: Carla Sella
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: BUG:  attaching a usb based music player to a usb port  does not
 open banshee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm reporting upstream a bug I already have reported in launchpad for
Ubuntu.
When I attach a usb based music player to a usb port, banshee music
player does not open, but nautilus opens instead, when I used to use 
Ubuntu Natty inserting the music player opened banshee.
All the files in the music player are displayed in nautilus, if I click
on a music file, banshee then opens.
I have a  HP laptop model G62.
I expect banshee player to  open automatically if the mp4 player is
plugged into a usb port.

This is the bug I opened on launchpad with all the details:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/826806


-- 
Carla Sella
email: carla.sella@gmail.com
https://launchpad.net/~carla-sella

