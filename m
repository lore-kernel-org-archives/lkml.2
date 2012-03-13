Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2CMLEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:04:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41914 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CMLEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:04:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] vfs: reorganize do_lookup
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	<1331038601-20353-8-git-send-email-miklos@szeredi.hu>
	<20120313093445.GB11797@infradead.org>
Date: Tue, 13 Mar 2012 12:04:16 +0100
In-Reply-To: <20120313093445.GB11797@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 05:34:45 -0400")
Message-ID: <87ty1s92z3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>> +	/*
>> +	 * Don't bother with __d_lookup: callers are for creat as
>> +	 * well as unlink, so a lot of the time it would cost
>> +	 * a double lookup.
>> +	 */
>> +	dentry = d_lookup(base, name);
>
> This comment isn't true anymore now, although the actual code should
> still be fine given that we already did the __d_lookup before for
> regular lookups.

Okay.

Thanks,
Miklos
