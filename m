Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1JWM3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:29:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38323 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437Ab1JWM3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:29:38 -0400
X-Sasl-enc: 0YmyW1YP9TdX2/slju9yU6J04rkJ5iKn8h0cAjNR3u6k 1319372977
Date: Sun, 23 Oct 2011 14:29:27 +0200
From: Greg KH <greg@kroah.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        John Hawley <warthog19@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.0.7 now on kernel.org
Message-ID: <20111023122927.GB25711@kroah.com>
References: <20111023083131.GA13802@kroah.com>
 <4EA40795.3070603@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA40795.3070603@example.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 02:24:53PM +0200, Piotr Hosowicz wrote:
> On 23.10.2011 10:31, Greg KH wrote:
> 
> >You will note that the files are signed with my new kernel release
> >signing key, and that the .tar file is signed, and then compressed, so
> >there is not signatures for the individual compressed files.
> 
> And why is that? It's less handy.

I'll let hpa answer that one, he changed it for a good reason that I
can't recall at the moment :)

hpa?

thanks,

greg k-h
