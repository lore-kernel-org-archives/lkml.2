Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2EALHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:07:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2EALHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120430135123.GA14330@kroah.com>
References: <1335779216-32068-1-git-send-email-sasikanth.v19@gmail.com>
	<20120430135123.GA14330@kroah.com>
Date: Tue, 1 May 2012 16:37:15 +0530
Message-ID: <CAOJFanVKqbiVQ6dUPSbpc8A43_7-vYqGCDdsFXFWMnwxcHPWbQ@mail.gmail.com>
Subject: Re: [PATCH v2] sysfs: Removed dup_name entirely in sysfs_rename
From: Sasikanth babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 7:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 30, 2012 at 03:16:56PM +0530, Sasikantha babu wrote:
>> Since no one using "dup_name", removed it completely in sysfs_rename,
>>
>> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
>> ---
>>  fs/sysfs/dir.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> Have you tested this patch and renamed some sysfs files with it with
> SLAB_DEBUGGING enabled?  There was some "odd" things with regards to
> names that I would like to ensure that is all still working properly
> with this patch.
>
> thanks,
>
> greg k-h

I had enabled SLAB debugging and  tested this patch by modifying few
existing sysfs entries and
newly created entries.

[sasikantha@localhost linux-2.6]$ cat .config | grep SLAB
CONFIG_SLAB=y
CONFIG_SLABINFO=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
[sasikantha@localhost linux-2.6]$

Did not face any issues while renaming.

Please let me know if there is any specific scenario that needs to be tested.

Thanks
Sasi
