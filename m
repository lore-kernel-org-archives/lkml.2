Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2DYLya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:54:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681Ab2DYLy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:54:28 -0400
Message-ID: <4F97E5F2.50501@suse.de>
Date: Wed, 25 Apr 2012 13:54:26 +0200
From: Ludwig Nussel <ludwig.nussel@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org,
        "Jan Kara (maintainer:EXT2 FILE SYSTEM)" <jack@suse.cz>,
        "Andrew Morton (maintainer:EXT3 FILE SYSTEM)" 
	<akpm@linux-foundation.org>,
        "Andreas Dilger (maintainer:EXT3 FILE SYSTEM)" 
	<adilger.kernel@dilger.ca>,
        "\"Theodore Ts'o\" (maintainer:EXT4 FILE SYSTEM)" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] implement uid and gid mount options for ext2, ext3 and
 ext4
References: <1335281356-2943-1-git-send-email-ludwig.nussel@suse.de> <4F971936.6070809@landley.net>
In-Reply-To: <4F971936.6070809@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On 04/24/2012 10:29 AM, Ludwig Nussel wrote:
>> Further development of a patch I sent years ago. I didn't find the
>> time to address the concerns raised back then and forgot about the
>> patch. Now here it is again.
> 
> The doc bits look fine:
> 
> Acked-by: Rob Landley <rob@landley.net>
> 
> As for the design: why isn't this in the VFS instead of in ext234? It
> seems like VFAT is more likely to need this, and I vaguely recall virtfs
> (I.E. 9pfs) doing something similar...?

Yes, file systems like FAT that do not store ownership information
themselves have a uid option. I agree that handling that in vfs itself
would be the more generic solution. It would require more work though.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
