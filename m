Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab2JMH10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 03:27:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60506 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JMH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 03:27:25 -0400
Message-ID: <5079164D.4030307@gmail.com>
Date: Sat, 13 Oct 2012 09:20:45 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
In-Reply-To: <20121013002003.GL2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/10/2012 02:20, Al Viro ha scritto:
> 	Stuff from Jeff Layton, mostly.  Sanitizing interplay between
> audit and namei, removing a lot of insanity from audit_inode() mess
> and getting things ready for his ESTALE patchset.  Please, pull from
> the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>

Al,

do you see any problem to apply the patch series "drop vmtruncate"? Do 
you think it's better to push it for 3.8?

Thanks,

Marco
