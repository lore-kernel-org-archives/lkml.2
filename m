Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2JPHLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:11:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64372 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2JPHLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:11:40 -0400
Date: Tue, 16 Oct 2012 00:11:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com
Subject: Re: [PATCH 1/2] Staging: android: binder: Fix memory leak on
 thread/process exit
Message-ID: <20121016071136.GB5172@kroah.com>
References: <20121015235836.GA3214@kroah.com>
 <1350347562-32643-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350347562-32643-1-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:32:41PM -0700, Arve Hjønnevåg wrote:
> If a thread or process exited while a reply, one-way transaction or
> death notification was pending, the struct holding the pending work
> was leaked.
> 
> Change-Id: I2eaafaba1c0ecda3ec0872d449dc16d0721c21e7

What is this field?  Please don't include this in kernel patches, it
forces me to edit the patch by hand :(

Also, this should go to older kernels, right?

greg k-h
