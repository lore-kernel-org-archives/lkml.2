Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1AQKah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:30:37 -0500
Received: from shiva144.upmc.fr ([134.157.0.144]:64246 "EHLO shiva.upmc.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751438Ab1AQKae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:30:34 -0500
X-Greylist: delayed 1207 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 05:30:34 EST
X-Ids: courriel2
Message-ID: <4D34158E.6090204@free.fr>
Date: Mon, 17 Jan 2011 11:10:22 +0100
From: Bernard Pidoux <bpidoux@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101213 Mandriva/3.0.11-0.1mdv2010.1 (2010.1) Thunderbird/3.0.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Bernard Pidoux <bernard.pidoux@upmc.fr>, Bernard Pidoux <bpidoux@free.fr>,
        npiggin@gmail.com
Subject: Kernel panic - fat_evict inode - 2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I observed a kernel panic and Linux reboot just after requesting
eject of an USB memory stick (that appears like a 2 Go disk)

Unfortunately, netconsole report did not work and I had just time
to take a screen picture.

In an attempt to duplicate the system failure I unplugged the stick, put 
it back on the USB plug and right click on the disk icone
to eject the device but I could not reproduce the issue.

In short the panic message says :

kernel panic - not syncing : Fatal exception
Pid: 2567, comm: tracker-niner-f Tainted: G D 2.6.37

panic
? kmsg_dump
oops_end
no_context
__bad_area_nosemaphore
__bad_area
bad_area
do_page_fault
? find_get_page
? trace_hardirqs_off_thunk
page_fault
? __lock_acquire
? filemap_fdatawait_range
lock_acquire
? fat_detach
_raw_spin_lock
? fat_detache
fat_detach
fat_evict_inode
evict
iput
fsnotify_destroy_mark
sys_inotify_rm_watch
system_call_fastpath
panic occured switching .....


Photo of the screen is here :

http://f6bvp.free.fr/fat_evict_inode.jpg

Bernard Pidoux


