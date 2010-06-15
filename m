Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0FOSfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:35:17 -0400
Received: from kroah.org ([198.145.64.141]:47396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab0FOSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:35:15 -0400
Date: Tue, 15 Jun 2010 11:35:01 -0700
From: Greg KH <greg@kroah.com>
To: Howard Chu <hyc@symas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/2] tty: add EXTPROC support for LINEMODE
Message-ID: <20100615183501.GA22092@kroah.com>
References: <4C120D8A.8050207@symas.com>
 <87631pq2aj.fsf@basil.nowhere.org>
 <4C121B4C.2000702@symas.com>
 <4C12E4B7.4020900@symas.com>
 <4C17C190.1020000@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17C190.1020000@symas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 11:08:16AM -0700, Howard Chu wrote:
> Paraphrased from the 1989 BSD patch by David Borman @ cray.com:

<snip>

This is the stuff you need in the 1/2 patch, otherwise it will be lost.

Does the build break if you don't apply the second patch?  Or is that
just needed to hook everything up for all of the arches?  We can't break
things inbetween each patch.

Care to resend?

thanks,

greg k-h
