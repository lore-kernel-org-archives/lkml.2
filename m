Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1FUMyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:54:38 -0400
Received: from mta21.charter.net ([216.33.127.81]:36795 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1FUMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:54:33 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 08:54:32 EDT
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=8DFDbwKGSZsA:10 a=0xc6OLWX_2kA:10
 a=8nJEP1OIZ-IA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=TNQT7g5JQnDhtsQCR-cA:9
 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E009485.7090400@gregd.org>
Date: Tue, 21 Jun 2011 07:54:29 -0500
From: Greg Dietsche <greg@gregd.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: 3.0 rc3 bug & warning fs/inode.c && fs/fs-writeback.c
References: <4E008DD0.2090809@gregd.org> <20110621124556.GZ11521@ZenIV.linux.org.uk>
In-Reply-To: <20110621124556.GZ11521@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,
On 06/21/2011 07:45 AM, Al Viro wrote:
>
> Which filesystems had been mounted?  That looks like a stray pointer
> to struct inode (i.e. outliving the inode eviction on final iput());
> might be the one fixed by commit 50338b889dc504c69e0cb316ac92d1b9e51f3c8a,
> might be something else...
>
I'm running ext4 on all partitions currently. I've got to go to work 
now, so I'll reply to any more emails and take a look at that commit 
tonight when I get home.

thanks,
Greg
