Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1FMCBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 22:01:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1FMCBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 22:01:08 -0400
Message-ID: <4DF57067.2040808@cn.fujitsu.com>
Date: Mon, 13 Jun 2011 10:05:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates
References: <1307879298-sup-3080@shiny> <m262oar1a9.fsf@firstfloor.org>
In-Reply-To: <m262oar1a9.fsf@firstfloor.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 10:00:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 10:00:51
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09:02, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
>> Hi everyone,
>>
>> The for-linus branch of the btrfs unstable tree:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus
> 
>>
>> Has our current queue of fixes.  Josef's is the biggest pile, mostly in
>> the allocator.  Josef and I both managed to merge his patch to avoid
>> mapping the extent buffer if skip_locking was set, git merge is just a
>> little too easy sometimes (I double checked the resulting code).
> 
> The new in 3.0 btrfs warnings on every build are still there:
> 
> fs/btrfs/sysfs.c:76: warning: ‘btrfs_root_attrs’ defined but not used
> fs/btrfs/sysfs.c:97: warning: ‘btrfs_super_attrs’ defined but not used
> fs/btrfs/sysfs.c:153: warning: ‘btrfs_super_release’ defined but not used   
> fs/btrfs/sysfs.c:160: warning: ‘btrfs_root_release’ defined but not used
> 
> These are not even used inside any ifdef. It's unclear to me: were
> these supposed to be used or removed?
> 
> Probably better to remove since they seem to be untested, unless
> it was a merge error?
> 
