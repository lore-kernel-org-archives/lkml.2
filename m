Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1CKShQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:37:16 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:46156 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1CKShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:37:13 -0500
Date: Fri, 11 Mar 2011 19:37:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Hounschell <markh@compro.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kernel git bisect question
Message-ID: <20110311183711.GA559@merkur.ravnborg.org>
References: <4D793414.4090206@compro.net> <20110310215438.GE12521@home.goodmis.org> <4D7A6A99.5070304@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A6A99.5070304@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 01:31:53PM -0500, Mark Hounschell wrote:
> On 03/10/2011 04:54 PM, Steven Rostedt wrote:
> > On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
> >> Between git bisect [good | bad ]s should I always "make clean" or can I
> >> count on the build system to take care of everything properly?
> > 
> 
> I'm trying to bisect between 2.6.35 and 2.6.36. What have I done wrong?
> Here is exactly what I've done. Why after my second "git bisect bad" do
> I get a Makefile for 2.6.35-rc1 and then after the fourth I get a Makefile
> for 2.6.34??

The development is not linear.
So you see a commit developed on top of 2.6.34 that was included in 2.6.35.
This is normal.

	Sam
