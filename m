Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2KBX30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:29:26 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48927 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750776Ab2KBX3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:29:24 -0400
Date: Fri, 2 Nov 2012 16:29:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Suspend/resume without VT switches
Message-ID: <20121102162937.1ec88cf1@jbarnes-desktop>
In-Reply-To: <7608326.fQBj17U8Wv@vostro.rjw.lan>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
	<7608326.fQBj17U8Wv@vostro.rjw.lan>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 22:51:07 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, November 02, 2012 02:43:39 PM Jesse Barnes wrote:
> > I've lightly tested this with X and it definitely makes my
> > suspend/resume sequence a bit prettier.  It should speed things up
> > trivally as well, but most of those gains come from other changes to the
> > i915 driver (posted earlier to intel-gfx).
> > 
> > Any thoughts?
> 
> I like the idea.
> 
> > I suspect we'll have to be more defensive about the
> > resume configuration in case the BIOS did something weird, but overall I
> > think we should be able to do this one way or another.
> 
> Perhaps patch [1/2] should be [2/2] and vice versa? :-)

But then it wouldn't compile?  I added the variable first, defaulting
to the current behavior, then made i915 support it and set the variable
to false there...  At least, that's what I intended to do.

-- 
Jesse Barnes, Intel Open Source Technology Center
