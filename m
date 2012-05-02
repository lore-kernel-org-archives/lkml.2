Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2EBVBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:01:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2EBVBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:01:17 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 17:01:17 EDT
MIME-Version: 1.0
In-Reply-To: <20120502201055.GA26148@kroah.com>
References: <1335779216-32068-1-git-send-email-sasikanth.v19@gmail.com>
	<20120502201055.GA26148@kroah.com>
Date: Thu, 3 May 2012 02:24:34 +0530
Message-ID: <CAOJFanXfohBi3ox4XGJ8EQyukJwHsUwEwRPG5v0rGNqYtwhFLQ@mail.gmail.com>
Subject: Re: [PATCH v2] sysfs: Removed dup_name entirely in sysfs_rename
From: Sasikanth babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 1:40 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 30, 2012 at 03:16:56PM +0530, Sasikantha babu wrote:
>> Since no one using "dup_name", removed it completely in sysfs_rename,
>>
>> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
>
> What kernel version did you create this against?  There is some odd fuzz
> and offsets aren't right here, you should at the least, make it against
> Linus's latest tree, and ideally against linux-next, this one was made
> against neither, so I can't really apply it.
>
  The patch is against Linus latest tree only.  I got the same offsets after a
  fresh clone.
> Care to refresh it against Linus's tree and resend it so I can apply it?
   Will resend the patch with latest Linus's tree.
>
> It makes me wonder how you tested it...
   Tested on Kernel 3.4-rc5 version.
>
> greg k-h
