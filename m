Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab2K2FMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:12:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44362 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2K2FMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:12:00 -0500
Date: Wed, 28 Nov 2012 21:13:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?44CQU3VnZ2VzdGlvbuOAkWRyaXZl?= =?utf-8?Q?rs=2Ftty=3A?=
 drivers/char/:  for MAX_ASYNC_BUFFER_SIZE
Message-ID: <20121129051335.GA4375@kroah.com>
References: <50B6E751.9000000@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6E751.9000000@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:40:49PM +0800, Chen Gang wrote:
> Hello Greg Kroah-Hartman:
> 
> for MAX_ASYNC_BUFFER_SIZE:
>   it is defined as 4096;
>   but for the max buffer size which it processes, is 65535.
>   so suggest to #define MAX_ASYNC_BUFFER_SIZE 0x10000  (better than 0xffff)

Please, send tty questions to the linux-serial@vger.kernel.org list
also.

And, I really don't understand here, why do you want to change this?
What is it going to change?  And why?

greg k-h
