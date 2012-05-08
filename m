Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab2EHAba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:31:30 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44807 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2EHAb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:31:29 -0400
Date: Mon, 7 May 2012 17:31:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 57/75] exit_signal: simplify the "we have changed execution
 domain" logic
Message-ID: <20120508003125.GC4150@kroah.com>
References: <20120504204229.240075699@linuxfoundation.org>
 <1336355835.8274.262.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336355835.8274.262.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 02:57:15AM +0100, Ben Hutchings wrote:
> On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Oleg Nesterov <oleg@redhat.com>
> > 
> > commit e636825346b36a07ccfc8e30946d52855e21f681 upstream.
> [...]
> 
> This and the following commit b6e238dceed36891cc633167afe7151f1f3d83c5
> ('exit_signal: fix the "parent has changed security domain" logic')
> appear to be applicable to 3.2.y as well.  Should I queue them up?

Yes, that would be good to do.

greg k-h
