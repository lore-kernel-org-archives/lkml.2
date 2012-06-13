Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2FMBDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:03:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2FMBDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:03:17 -0400
Date: Tue, 12 Jun 2012 18:03:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        oneukum@suse.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 02/13] code cleanup
Message-ID: <20120613010309.GC6765@kroah.com>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
 <1339057243-10029-3-git-send-email-stefani@seibold.net>
 <877gvjtrsf.fsf@nemi.mork.no>
 <1339060906.11583.9.camel@wall-e>
 <87vcj3s8fm.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87vcj3s8fm.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 12:49:49PM +0200, Bjørn Mork wrote:
> Stefani Seibold <stefani@seibold.net> writes:
> 
> > If it is necessary...
> 
> So, why is it necessary for you to change this code *from* the style
> recommended by CodingStyle and LDD3?
> 
> Quoting from LDD3:
> 
>  "Error recovery is sometimes best handled with the goto statement. We
>   normally hate to use goto, but in our opinion, this is one situation
>   where it is useful. Careful use of goto in error situations can
>   eliminate a great deal of complicated, highly-indented, "structured"
>   logic. Thus, in the kernel, goto is often used as shown here to deal
>   with errors."
> 
> > Compacting improves since it will make the code more readable.
> 
> No, it does not.  As pointed out, instead of having to follow a single
> exit path from each function, your changes makes it necessary to follow
> n exit paths.  That does not make the code more readable, and it
> contradicts both CodingStyle and LDD3.
> 
> Note that I am not stating in any way that those documents contain
> absolute truths and that you cannot write your own driver the way you
> like.  I do however find it extremely strange that you insist on
> changing a coding example to be inconsistent with those documents.
> Regardless of whether you agree with them or not, you must see that such
> inconsistent guidelines will be a problem for anyone trying to use this
> code for learning?

I totally agree, the original style should be preserved.

thanks,

greg k-h
