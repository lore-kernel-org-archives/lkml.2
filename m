Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2IRUjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:39:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2IRUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:39:41 -0400
Date: Tue, 18 Sep 2012 13:39:38 -0700
From: Kenny Root <kroot@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Ayer <agwa@andrewayer.name>
Subject: Re: [PATCH 0/2 RESEND] POSIX-compliant version of fchmodat with flag
 argument
Message-ID: <20120918203853.GA25180@google.com>
References: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 05:53:44PM -0800, Andrew Ayer wrote:
> Besides the POSIX-compliance, this patch will make it possible to
> ensure, in a race-free way, that you do not follow symlinks when
> chmodding. Previously, you could open a file with O_NOFOLLOW and fchmod
> it, but this only worked if you had read or write permissions on the
> file.  Now you can open the file with O_PATH|O_NOFOLLOW and do fchmodat
> with AT_EMPTY_PATH.

Alexander, this patch solves a particular problem in a useful way. I
find it useful and I would be happy to see it included in mainline.

Thanks,
Kenny
