Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2HFDWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:22:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62430 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HFDWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:22:18 -0400
Message-ID: <501EDDA0.1090202@landley.net>
Date: Sun, 05 Aug 2012 15:54:56 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sachidananda Urs <sacchi@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Fengguang Wu <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/filesystems/porting: Update documentation.
References: <1344015265-6752-1-git-send-email-sacchi@gmail.com>
In-Reply-To: <1344015265-6752-1-git-send-email-sacchi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 12:34 PM, Sachidananda Urs wrote:
> ->get_sb() is no longer used, update documentation to use ->mount(). Also added
>   a example for struct file_system_type.
> 
> Signed-off-by: Sachidananda Urs <sacchi@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

(Yesterday at Texas Linuxfest I _finally_ got some of the gpg signatures
to resurrect my kernel.org account, but I'll forward this through
-trivial in the meantime unless somebody else picks it up first.)

Thanks,

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
