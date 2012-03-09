Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab2CIUxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:53:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49976 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2CIUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:53:04 -0500
Date: Fri, 9 Mar 2012 14:52:57 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [ 17/68] regset: Return -EFAULT, not -EIO, on host-side memory
 fault
Message-ID: <20120309205257.GC23244@burratino>
References: <20120309194409.GA2069@kroah.com>
 <20120309190216.344083722@linuxfoundation.org>
 <20120309203446.GB23244@burratino>
 <20120309204150.GA2125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309204150.GA2125@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> "making things sane" is good enough for me :)

Thanks.  That answers my question.

> On Fri, Mar 09, 2012 at 02:34:46PM -0600, Jonathan Nieder wrote:

>> Part of the reason I am asking is to figure out whether the patch
>> ought to be applied to 2.6.32.y, too.
>
> Why do you think it should not be?

I think it should be.  If there were some motivation like "without
this patch, in circumstance X, gdb produces such-and-such bad
behavior", that would make it easier. ;-)

Ciao,
Jonathan
