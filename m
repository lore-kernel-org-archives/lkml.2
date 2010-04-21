Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0DUMyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:54:46 -0400
Received: from lo.gmane.org ([80.91.229.12]:57877 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0DUMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:54:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] Whitespace Coding style fixes.
Date: Wed, 21 Apr 2010 14:54:13 +0200
Message-ID: <20100421145413.6046dd4f@schatten.dmk.lab>
References: <1271833331-26973-1-git-send-email-justinmattock@gmail.com>
	<u2mb6fcc0a1004210003v5867afcfw4b112766a6951043@mail.gmail.com>
	<4BCEA499.6000308@gmail.com>
	<1271835281.1730.274.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053219053.adsl.alicedsl.de
In-Reply-To: <1271835281.1730.274.camel@Joe-Laptop.home>
X-Newsreader: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 00:34:41 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2010-04-21 at 00:09 -0700, Justin P. Mattock wrote:
> > On 04/21/2010 12:03 AM, Alexey Dobriyan wrote:
> > > You screw up git-blame.
> > how does this patch screw it up?
> 
> Alexey just doesn't like whitespace patches.
> 
> Whitespace patches don't really "screw up" git blame.
> 
> git blame displays the current version of a file
> with line-by-line commits and the date each line
> was last modified.
> 
> So whitespace changes make it harder to find which patch
> introduced the last logical change for a particular line.

git blame -w 

