Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2JMH7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 03:59:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52031 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2JMH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 03:59:29 -0400
Message-ID: <50791DD1.7050708@gmail.com>
Date: Sat, 13 Oct 2012 09:52:49 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] vfs pile 3
References: <20121013002003.GL2616@ZenIV.linux.org.uk> <5079164D.4030307@gmail.com> <20121013075128.GQ2616@ZenIV.linux.org.uk>
In-Reply-To: <20121013075128.GQ2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/10/2012 09:51, Al Viro ha scritto:
> On Sat, Oct 13, 2012 at 09:20:45AM +0200, Marco Stornelli wrote:
>> Il 13/10/2012 02:20, Al Viro ha scritto:
>>> 	Stuff from Jeff Layton, mostly.  Sanitizing interplay between
>>> audit and namei, removing a lot of insanity from audit_inode() mess
>>> and getting things ready for his ESTALE patchset.  Please, pull from
>>> the usual place -
>>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>>>
>>
>> Al,
>>
>> do you see any problem to apply the patch series "drop vmtruncate"?
>
> It's somewhat pointless on its own...  If you were doing something with
> the callers afterwards - sure, it would be make sense, but as it is...
>

The goal of the patch was to remove a deprecated function trying to 
improve the code, removing the inode operation and doing a general 
cleanup. It's pointless for me to have "dead"/"old" code, however thanks 
for you comment.

Marco
