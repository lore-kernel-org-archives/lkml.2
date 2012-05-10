Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2EJN7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:59:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab2EJN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:59:10 -0400
Date: Thu, 10 May 2012 06:59:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ben Minerds <puzzleduck@gmail.com>, alan@lxorguk.ukuu.org.uk,
        richard.weinberger@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21] USB: serial: Changes to conform with checkpatch.sh
 script. space before tabs.
Message-ID: <20120510135906.GA20099@kroah.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
 <1336641447-23194-2-git-send-email-puzzleduck@gmail.com>
 <4FAB9B98.5040007@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAB9B98.5040007@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:42:32PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 10-05-2012 13:17, Ben Minerds wrote:
> 
> >Removed 3 checkpatch.sh warnings.
> 
> >Signed-off-by: Ben Minerds<puzzleduck@gmail.com>
> 
>    But why you didn't merge this with patches 3, 5, 7, 8, 10, 12,
> 14, 16, 17, and 20 which claim to do the same change?!

Yes I agree, you took it too far this time.  Do one "logical" change at
a time please.

Third time's a charm?

greg k-h
