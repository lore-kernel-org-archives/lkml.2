Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2DWVTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:19:44 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62017 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2DWVTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:19:43 -0400
Date: Mon, 23 Apr 2012 14:19:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Autif Khan <autif.mlist@gmail.com>
Cc: dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: kernel link error - undefined references for built-in.o
Message-ID: <20120423211939.GA3255@kroah.com>
References: <CADzUK1+JG=nLMygnURUorDAKcguEr-f_mds0bcY4FEGi1VP9eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADzUK1+JG=nLMygnURUorDAKcguEr-f_mds0bcY4FEGi1VP9eA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 05:09:00PM -0400, Autif Khan wrote:
> CONFIG_ZCACHE=y
> CONFIG_ZSMALLOC=m

This is probably the problem.

If you change either of these to match (i.e. both 'y' or both 'm') does
the build problem go away?

If so, someone should send me a patch fixing this up....

thanks,

greg k-h
