Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564Ab2FDNOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:14:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33556 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2FDNO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120604125356.GB7738@localhost>
References: <1338813642-6476-1-git-send-email-liwp.linux@gmail.com>
	<20120604125356.GB7738@localhost>
Date: Mon, 4 Jun 2012 22:14:28 +0900
Message-ID: <CAEwNFnDmQZa9gXcKqLXipWSdVfNXszeBWZrc-MDS50A6K0CEww@mail.gmail.com>
Subject: Re: [PATCH] remove no longer use of pdflush interface
From: Minchan Kim <minchan.kim@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <liwp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 9:53 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Wanpeng,
>
> On Mon, Jun 04, 2012 at 08:40:42PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>> remove no longer use of pdflush interface nr_pdflush_threads.
>
> The patch looks good in itself: the nr_pdflush_threads takes no effect
> for many of the recent kernels. But what's the normal process of
> interface removal?  Shall we carry some warning printk for some time
> first or whatever?

Yes. you have to add printk warning for noticing it deprecated.
And add descriptoin in Documentation/ABI/obsolete/ and
Documentation/feature-removal-schedule.txt

I don't know how long we maintain it. Is there any rule for it?
Maybe 1-year is suitable, IMHO.

Thanks.
-- 
Kind regards,
Minchan Kim
