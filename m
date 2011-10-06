Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab1JFV7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:59:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50885 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1JFV7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:59:22 -0400
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 23:59:21 +0200
Message-ID: <CAEGpDuYd02LPME5tkuu1FK2JseHy5CFCfNg=-CTeO6vKdx90qQ@mail.gmail.com>
Subject: kernel crash
From: Pau Espin Pedrol <pespin.shar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since more a less kernel 3.0 my intel i5 has kernel panics (computer
stops working at all and keyboard leds start to blink).
I can't recall exactly, but I think it was more a less the same time
since I started using nvidia drivers with twinview (2 screens), which
could may be the cause?

I'm using archlinux, so I've been told the kernel is a vanilla kernel.

I can somehow "reproduce" the crash here. I mean, every day when I
boot my PC, I know a kernel crash will happen in the next 1-15 min
aprox. Then I reboot my PC and I don't have any kernel panic till next
day.
It sometimes happens at bootime, sometimes when I'm just logged in
into X server and doing work or when I halt the computer.

I was able to get some photos of the kernel backtrace when the crash
appears while booting/halting.
Here you have the link to a tar.gz file which contains several photos
with backtraces:
http://pespin.espeweb.net/tmp/kernel-panic/kernel-panic-bt.tar.gz

You can find more information of the PC in several text files I
uploaded tho the same dir: http://pespin.espeweb.net/tmp/kernel-panic/
Let's hope they are of help to you.


If you need me to try something or give me more information just tell me!

PS: Please add me to the CC when answering this mail as I am not
subscribed to the ml ;)

--
Pau Espin Pedrol
mail/jabber: pespin.shar@gmail.com
http://blog.espeweb.net
