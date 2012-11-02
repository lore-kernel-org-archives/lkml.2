Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2KBA6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:58:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58983 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KBA6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:58:53 -0400
Date: Thu, 1 Nov 2012 17:58:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stan Hu <stanhu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help with diagnosing kernel oops in __mutex_lock_slowpath
Message-ID: <20121102005852.GA2575@kroah.com>
References: <CAMBWrQ=Xrp-_opV0ej4rn20p3yTUP0TmYQHr5nG79szC0=WUDA@mail.gmail.com>
 <CAMBWrQm6CacSoUxZdNA9XPhDMqyAt2R15ZXxpCLEZcRvEeRiCg@mail.gmail.com>
 <20121102001429.GA2129@kroah.com>
 <CAMBWrQmQqF7yjmZWkVFbjWrPUane-tB2sm6BCgn-x4QnXWYVgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMBWrQmQqF7yjmZWkVFbjWrPUane-tB2sm6BCgn-x4QnXWYVgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 05:23:48PM -0700, Stan Hu wrote:
> Unfortunately, with this board I am using, it would be a significant
> effort for me to get 3.6 or 3.7 running.  Do you have any suggestions
> of what I should look for in the 3.2 kernel?

Why is that, because companies don't have their board support upstream?
If you are dealing with a non-stock kernel.org kernel, there's not much
we can do to help, try asking the company that provided that patches you
are using.

And no, I don't what to look for for this, sorry, 3.2 was a few tens of
thousands of patches ago :)

good luck,

greg k-h
