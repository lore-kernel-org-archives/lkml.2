Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0J0HSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:18:22 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:49566 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0J0HSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:18:20 -0400
Message-ID: <4CC7D238.9010903@bfs.de>
Date: Wed, 27 Oct 2010 09:18:16 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete double
 assignment
References: <1288088743-3725-1-git-send-email-julia@diku.dk> <1288088743-3725-9-git-send-email-julia@diku.dk> <20101027010908.GA29299@khazad-dum.debian.net>
In-Reply-To: <20101027010908.GA29299@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Henrique de Moraes Holschuh schrieb:
> On Tue, 26 Oct 2010, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Delete successive assignments to the same location.
> 
> There are often results of mismerges or other assorted screw ups, often
> done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
> development.
> 
> The patch is correct, and I thank you for the head's up.  But let me
> track down what caused it first, hmm?  I also highly recommend that this
> should be done in all cases you find, instead of just blindly fixing the
> assignment.  I suggest using git --blame to track down what added the
> duplicated assignments, and check if it looks sane...
> 
> It is often a VERY BAD IDEA to remove such markers of potential
> brokennes without checking out if they're actually helpfully trying to
> warn you of worse badness :p
> 
> But hey, maybe you've already done that.  If you did, I apologise for
> preaching to the choir.
> 

IMHO that goes beyond what to expect from a kernel janitor. They try to
identify minor problems like double inits; why they occur is part of the
"maintainer job". The people (should) have much better understand of the
code and can identify omissions in there work flow much more easy. To be
fair some problems are hard to identify/fix but you can not move that to
the janitor.

just my 2 cents,
 wh
