Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2CGTyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:54:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54503 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020Ab2CGTrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:32 -0500
Date: Wed, 7 Mar 2012 11:47:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiachen Dong <xiachendong@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36 and higher version kernel slower than 2.6.25.1 kernel?
Message-ID: <20120307194728.GA26341@kroah.com>
References: <BAY167-W124DBC204D9E95FC00BAA44BD560@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY167-W124DBC204D9E95FC00BAA44BD560@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 12:04:33PM -0500, Xiachen Dong wrote:
> 
> Hi,
> 
> Recently we upgrade the OS for our AT91RM9200 platform from 2.6.25.1
> to 2.6.36. We run the SQLITE3 database insertion tests for the new
> kernel. The test result shows that 2.6.36 kernel is around 10% slower
> than the 2.6.25.1.

Ick.

As you noted this is still present in 3.0.23, any chance to try out
3.2.9?

And as you seem to have a good reproducable test, can you run 'git
bisect' between 2.6.35 and 2.6.36 to find the patch that causes this
problem so we can work on resolving it?

thanks,

greg k-h
