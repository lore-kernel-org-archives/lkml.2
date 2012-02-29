Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2B2Uxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:53:42 -0500
Received: from adamg.eu ([91.192.224.99]:45314 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab2B2Uxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:53:42 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.2.2] oom + no-killable-processes.
Date: Wed, 29 Feb 2012 21:53:35 +0100
Message-ID: <1888499.Wt33pfNhUs@vmx>
User-Agent: KMail/4.8.0 (Linux/3.2.7-1; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120229200910.GB31348@kroah.com>
References: <3905756.9FRF7uBtcE@vmx> <20120229200910.GB31348@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 of February 2012 12:09:10 Greg KH wrote:
> On Wed, Feb 29, 2012 at 08:28:23PM +0100, Paweł Sikora wrote:
> > Hi all,
> > 
> > i've found on my 8-core opterons following oops (oom+nokillable): http://imgbin.org/index.php?page=image&id=6945
> > usualy the kernel just kills processes from userspace but this time something has gone wrong...
> > sysrq was dead, so no more stacktraces :/
> 
> Is this something new with 3.2.2?

i see such nokillable oom first time. the 3.1.x stable has been working for few months.
as you can see on the oops timestamp the 3.2.2 failed after ~27.5d so it isn't an immediate
crash which can be easily bisected :/ currently i'm stressing the 3.2.7...

