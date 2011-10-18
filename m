Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab1JRJDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:03:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47559 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JRJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:03:44 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: toshi.okajima@jp.fujitsu.com
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/13] read-only remount race fix v7
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	<4E968EE7.2080803@jp.fujitsu.com> <4E9D1C73.3000205@jp.fujitsu.com>
Date: Tue, 18 Oct 2011 11:02:46 +0200
In-Reply-To: <4E9D1C73.3000205@jp.fujitsu.com> (Toshiyuki Okajima's message of
	"Tue, 18 Oct 2011 15:28:03 +0900")
Message-ID: <87d3dur7t5.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> writes:

> Miklos-san,
>
> (2011/10/13 16:10), Toshiyuki Okajima wrote:
>> Hi.
>> 
>> (2011/10/12 23:48), Miklos Szeredi wrote:
>>> Here's an update of the read-only remount race fixes.
>>>
>>> It should now fix the races after unlink.  I haven't been able to
>>> trigger the bad behavior with the test scripts provided by Toshiyuki
>>> Okajima.
>>>
>>> Toshiyuki-san, could you please test these patches too?
>> OK. I will test them with ext4. Please wait.
> I have tested your latest patch set by my reproducer with ext4.
>
> On my environment, this reproducer usually detects
>  "EXT4-fs (xxx): Couldn't remount RDWR because of unprocessed orphan inode list"
> message within 20 minutes when I use your previous patch set.
> However, when I use your latest patche set, this producer has not yet 
> detected the message for 2 days.
>
> So, I think your latest patch set fixes the problem that delayed deletion 
> can start when we remount a superblock read-only.
>
> Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Thanks for testing.

Miklos
