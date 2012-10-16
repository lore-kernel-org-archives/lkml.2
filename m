Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2JPHMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:12:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2JPHMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:12:34 -0400
Date: Tue, 16 Oct 2012 00:12:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com
Subject: Re: [PATCH 2/2] Staging: android: binder: Allow using highmem for
 binder buffers
Message-ID: <20121016071231.GC5172@kroah.com>
References: <20121015235836.GA3214@kroah.com>
 <1350347562-32643-1-git-send-email-arve@android.com>
 <1350347562-32643-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350347562-32643-2-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:32:42PM -0700, Arve Hjønnevåg wrote:
> Change-Id: I19be5fd89c194abcb8b041e2dd6c4d71ae7b1cc2

Again with the change-id field :(

And please provide some information here, _why_ do we want to allow
highmem for binder buffers?  What does this solve?  Is it a bug or just
a feature enhancement?  Depending on what it is depends on what release
it should go into.

thanks,

greg k-h
