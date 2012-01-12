Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2ALWCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:02:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46515 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab2ALWCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:02:47 -0500
X-Sasl-enc: eyQ9TdNzP2m4N0yjpfWOkcTLEvu05HBPciNgT81qxaEE 1326405766
Date: Thu, 12 Jan 2012 14:02:39 -0800
From: Greg KH <greg@kroah.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Paul Taysom <taysom@chromium.org>, Paul Taysom <taysom@google.com>,
        Olof Johansson <olofj@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Theodore Tso <tytso@google.com>, Andrew Morton <akpm@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-ID: <20120112220239.GA1542@kroah.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
 <20120112213830.GB17405@kroah.com>
 <20120112215331.GB18166@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112215331.GB18166@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 01:53:31PM -0800, Mandeep Singh Baines wrote:
> > > Downstream-bug-report: http://crosbug.com/24165
> > 
> > Is that a regular field that we now use?
> > 
> 
> Hi Greg,
> 
> What is the conventional way of doing this? There is a lot of good
> data in the bug report which might be useful to reviewers. We
> couldn't find a de-facto way of referencing the downstream bug database
> so we just made up a new field. Sorry. We'll use the correct
> field name next time.
> 
> So what is the correct field name?

I don't know, I was asking if this is what we are now using.  I usually
just put it in the body of the changelog, something like:

	More details about this can be found at: http://crosbug.com/24165

Making sure that no relevant info is only at that link and not in the
changelog comment, as bug reporting sites have a tendancy to disappear
at times.

thanks,

greg k-h
