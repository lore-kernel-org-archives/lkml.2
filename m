Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab1LFLHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:07:33 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45085 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933153Ab1LFLHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:07:31 -0500
Subject: Re: [PATCH 2/5 resend] Thaw the journal when you unfreeze the fs.
From: Matt Fleming <matt@console-pimps.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Surbhi Palande <surbhi.palande@canonical.com>
In-Reply-To: <1323118489-16326-3-git-send-email-kamal@canonical.com>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
	 <1323118489-16326-3-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 11:07:24 +0000
Message-ID: <1323169644.4838.13.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 12:54 -0800, Kamal Mostafa wrote:
> From: Surbhi Palande <surbhi.palande@canonical.com>
> 
> Thaw the journal so that transactions can resume
> 
> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/ext4/super.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Shouldn't this patch really be merged with [PATCH 1/5] ? Otherwise it's
possible to freeze a journal that will never be unfrozen, if say, you're
doing a git bisect and you have [PATCH 1/5] applied but not [PATCH 2/5].

-- 
Matt Fleming, Intel Open Source Technology Center

