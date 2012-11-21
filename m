Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2KWAJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:09:50 -0500
Received: from relay02.pair.com ([209.68.5.16]:2410 "HELO relay02.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751615Ab2KWAJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:09:49 -0500
X-Greylist: delayed 11599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 19:09:48 EST
X-pair-Authenticated: 199.188.183.126
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org> <20121120074123.24645.41965.stgit@blackbox.djwong.org> <20121121100809.GE23339@infradead.org> <x497gpevqoy.fsf@segfault.boston.devel.redhat.com> <20121121182901.GA4519@infradead.org> <20121121213732.GG30250@quack.suse.cz>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121121213732.GG30250@quack.suse.cz>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <293D7CE0-C899-43F8-B04E-EB31100C8888@dhnet.us>
Cc: Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "bpm@sgi.com" <bpm@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
X-Mailer: iPhone Mail (10A405)
From: Jeffrey Ellis <jellis@dhnet.us>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Date: Wed, 21 Nov 2012 18:09:48 -0500
To: Jan Kara <jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Best,
J. 

On Nov 21, 2012, at 4:37 PM, Jan Kara <jack@suse.cz> wrote:

> On Wed 21-11-12 13:29:01, Christoph Hellwig wrote:
>> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
>>>> I'd like to use this as a vehicle to revisit how dio completions work.
>>> 
>>> I don't like the sound of that.  ;-)  It sounds like this bugfix may get
>>> further delayed by the desire for unrelated code cleanup.
>> 
>> I've got a prototype that isn't much more invasive than the current
>> series.  I'll finish it up and run it through QA and will post it
>> tomorrow.
>  Great, I wanted to have a look into it but you beat me to it ;)
> 
>                                Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
