Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2BBVFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:05:30 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:39618 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756031Ab2BBVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
References: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 2 Feb 2012 13:05:07 -0800
Message-ID: <CAL1RGDWLM58+vBPEd-JKLN+MNHuX4JRme9GocsVCQsuxNU7R8w@mail.gmail.com>
Subject: Re: Linux 3.3-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 1:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> One thing that has happened is that I've liked seeing the merge
> message things that have come in through signed tags so much that I've
> decided to try to write more explanations even for the merges that
> don't get that kind of love from their subsystem maintainers. Some
> subsystem maintainers (David with networking is a good example) have
> tended to write nice good explanations in their pull requests, and
> I've started to try to make those kinds of things part of my merge
> messages.

I know you're rarely shy about giving feedback but I'm curious if we're
far enough along in this signed tag pulling stuff for you to have thoughts
about best practices for the tag contents.  For example if you look at
my recent 18d3e0d75079 is there anything you'd rather have different
(although of course that was a very boring tag with no controversial
contents and no conflicts)?  Any naming conventions for tags?  Anything
else you want an excuse to pontificate about?

Thanks,
 - R.
