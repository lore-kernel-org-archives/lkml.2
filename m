Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2BCW2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:28:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2BCW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:28:23 -0500
Date: Fri, 3 Feb 2012 14:28:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203222818.GG14209@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
 <20120203214435.GC12616@redhat.com>
 <20120203214719.GE14209@google.com>
 <20120203215349.GF9683@redhat.com>
 <20120203221409.GF14209@google.com>
 <20120203222329.GG9683@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203222329.GG9683@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 05:23:29PM -0500, Vivek Goyal wrote:
> Personally I consider it to be a debugging aid. User space applications
> should do what you suggested and that is take delta between certain
> periods.
> 
> Frankly speaking I have found it useful though. If I am debugging something,
> I don't have to reboot the system to reset the stats and calculating the
> difference from zero is easier for humans.

There are many things different people may find useful but we
shouldn't add userland visible interface with marginal usefulness like
this one.  Seriously, you can write up a ten line python script to
achieve what you want.  It's just sad. :(

-- 
tejun
