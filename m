Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0JJXgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 19:36:07 -0400
Received: from smtp13.ono.com ([62.42.230.16]:47529 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752326Ab0JJXgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 19:36:05 -0400
Date: Mon, 11 Oct 2010 01:36:03 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cifs or win, who is slow ?
Message-ID: <20101011013603.15f1c75c@werewolf.home>
X-Mailer: Claws Mail 3.7.6cvs54 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a curious problem sharing files with windows.
I have a home linus desktop/server, my main box, and a Win7 HTPC.
I share files from linux via samba. I auto-mount the htpc drive
from linux via cifs filesystem.
Both are connected to a WRT320N router, running dd-wrt. Wired network
is gigabit in both boxes.

Now the weird part. If I read or write files from the linux box to the
win drive automounted on linux, I get speeds in the order of 8 Mbits/s.
If I do the same from the win box to samba in the linuz box, I get 70 Mbits
thoughput. Both reading and writing.
So operating from the linux box through cifs is much slower than working
from the win box through samba.
But....
if I access the window share without the automounter, just through the
Network browsing feature in Gnome, I get again good speeds, about 40 Mbits/s.

Mount state is the same, whatever the method I use to acces the windows
drive:

//htpc/media/ /net/htpc/media cifs rw,relatime,unc=\\htpc\media,username=media,uid=3001,forceuid,gid=3000,forcegid,addr=192.168.1.20,file_mode=0664,dir_mode=0775,serverino,rsize=16384,wsize=57344 0 0

Anybody has noticed this ? Any clue ?
Is Linux CIFS slow or is win7 server slow ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
