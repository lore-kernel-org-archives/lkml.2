Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2IZXm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:42:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2IZXm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:42:27 -0400
Date: Wed, 26 Sep 2012 16:42:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20120926234223.GC26223@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
 <20120907011542.GA26688@kroah.com>
 <2329337.9aFzn0oRxF@tux200s>
 <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
 <20120910135803.GB2972@herton-Z68MA-D2H-B3>
 <20120910140734.GC2972@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910140734.GC2972@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:07:38AM -0300, Herton Ronaldo Krzesinski wrote:
> On Mon, Sep 10, 2012 at 10:58:03AM -0300, Herton Ronaldo Krzesinski wrote:
> > Couldn't it be that it happens because 3.4 doesn't have commits
> > b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 and
> > f01db988ef6f6c70a6cc36ee71e4a98a68901229 applied? May be they are needed
> > after all.
> 
> Nevermind, the description on the freedesktop bug report states that
> these commits were already tried and didn't work (if "3.4.10 + follow-up
> patches in Herton's reply - failed" means it)

Did anything ever come from this?  I haven't reverted anything, or
applied anything different, so if something needs to be done here,
please let me know.

thanks,

greg k-h
