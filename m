Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0JVSnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:43:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17191 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab0JVSlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:36 -0400
Date: Fri, 22 Oct 2010 11:40:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36, make oldconfig broken
Message-Id: <20101022114019.60839ff2.randy.dunlap@oracle.com>
In-Reply-To: <201010221229.36996.gene.heskett@gmail.com>
References: <201010221229.36996.gene.heskett@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 12:29:36 -0400 Gene Heskett wrote:

[adding linux-kbuild]

> Greets all;
> 
> I have managed to get 2.6.36 to a semi-usable state, but I have major 
> breakage yet.
> 
> Question: what happens if I simply move my working 2.6.35.7 .config into the 
> 2.6.36 tree and build it from that?

I think that it runs 'make oldconfig' automatically for you.

> It can't be any worse than what the broken 'make oldconfig' did to it.  What 
> it output changed the disk drivers, graphic card drivers and just plain 
> threw away at least a hundred lines in the multimedia drivers section.
> 
> How do you suggest I recover from this if just building from the 2.6.35.7 
> .conf doesn't work?

Please send your 2.6.35.7 .config file so that we can generate & see the
changes.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
