Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2EPHcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:32:13 -0400
Received: from natasha.panasas.com ([67.152.220.90]:38970 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2EPHcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:32:02 -0400
Message-ID: <4FB35665.5090908@panasas.com>
Date: Wed, 16 May 2012 10:25:25 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>
CC: Ludwig Nussel <ludwig.nussel@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net> <4FAD30D7.3070208@panasas.com> <20120515091542.51f3dd78@notabene.brown>
In-Reply-To: <20120515091542.51f3dd78@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 02:15 AM, NeilBrown wrote:

> On Fri, 11 May 2012 18:31:35 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 05/11/2012 06:49 AM, Roland Eggner wrote:
>>


Neil && Jan.

As I  said in my last mail:
	"Shared files" problem is not solved by mount options.

For me this is just a UNIX new-be 101 problem. You need to
share files with friends you make the mistake once. Then
you learn and you go on. It's a none problem.

Your removable media thing is just your "shared folder"
on a UNIX system. Deal with it. Da

Or go degrade your FS to vfat security. You are reluctant
to chmod all files to be world/group writeable but you
are doing just that with your mount option. Perhaps
when the chmod -R will scroll through you'd realize
that the passwords file you should remove. The POSIX
permissions are just for that purpose. "I set access
control at creation. Else slave to change them". The
mount option they specifically left out, not because
they were not clever, but because you don't want it.

BTW NTFS is like UNIX. If written in the right user-private
permissions you can't read them. Even admin. You can only chown
them.

BTW Neil with Kerberos auth in an NFS/CIFS shared device
like you mentioned, then a uid/gid is already associated
with the access automatically. It's a perfect IDEA for
these device makers. They need develop nothing only set it
up with the same NFS / SAMBA implementations they already
use.

And one last thing Neil. Yes an rm is a perfect rope
for an admin to hang itself, but it is not aimed at
auto-mounter scripts

I can't believe I got dragged into this again.

:-(
Boaz

