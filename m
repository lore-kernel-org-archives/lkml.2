Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0E3OBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 10:01:39 -0400
Received: from col0-omc3-s12.col0.hotmail.com ([65.55.34.150]:42632 "EHLO
	col0-omc3-s12.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab0E3OBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 10:01:38 -0400
Message-ID: <COL116-W109F123C01B20753913C91DAED0@phx.gbl>
X-Originating-IP: [84.216.39.104]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <tytso@mit.edu>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: What happened to mount option "noextents"
Date: Sun, 30 May 2010 15:53:10 +0200
Importance: Normal
In-Reply-To: <20100530123248.GO26177@thunk.org>
References: <COL116-W195C862FD57AC7C2144804DAED0@phx.gbl>,<20100530123248.GO26177@thunk.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 May 2010 13:53:24.0198 (UTC) FILETIME=[78CDD860:01CAFFFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Basically, since we couldn't think of a good use case where the mount
> options made sense, and ext4 has way too many mount options already, we
> decided to remove them.

The ext2/3 Windows driver doesn't support extents yet so one common use would be to do a mount -o remount,noextents and make a dir and copy the files you want to read from Windows to it. I think mount -o remount is something that is well known, if you use tune2fs you would need to do research before you know if the change starts working right a way or after a reboot or if it is valid only until reboot or is static, with mount -o remount there is no risk that you forget to set the flag back to the right value.

Also when I tryed tune2fs as you said, I got the following error message:

peter@sanna:~$ sudo tune2fs -O ^extents /dev/mapper/sannavg-home
tune2fs 1.41.4 (27-Jan-2009)
Clearing filesystem feature 'extent' not supported.
peter@sanna:~$ 

 		 	   		  
_________________________________________________________________
Vårfina smileys till Messenger här!
http://springpack.msn.se