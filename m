Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2DZNmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:42:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60896 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2DZNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:42:14 -0400
Date: Thu, 26 Apr 2012 06:42:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: puzzleduck@gmail.com
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, wgreathouse@smva.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: Changes to conform with coding style
Message-ID: <20120426134209.GA3121@kroah.com>
References: <1335432664-4587-1-git-send-email-puzzleduck@gmail.com>
 <4F994295.8010507@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F994295.8010507@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:41:57PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 26-04-2012 13:31, puzzleduck@gmail.com wrote:
> 
> >From: PuZZleDucK<puzzleduck@gmail.com>
> 
> >Removed some spaces before tabs and reformatted switch statement.
> 
> >Signed-off-by: PuZZleDucK<puzzleduck@gmail.com>
> 
>    Real name is needed here, no aliases allowed.

I agree, please see Documentation/SubmittingPatches for what
"Signed-off-by:" means, and why we can't accept this as-is.

greg k-h
