Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab2CGUdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:33:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33885 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2CGUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:33:09 -0500
Date: Thu, 8 Mar 2012 00:33:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] prctl: Use CAP_SYS_RESOUCE for PR_SET_MM option
Message-ID: <20120307203304.GB6215@moon>
References: <20120307125217.GC20558@moon>
 <1331152168.1798.13.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331152168.1798.13.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:29:28PM +0100, Paul Bolle wrote:
> On Wed, 2012-03-07 at 16:52 +0400, Cyrill Gorcunov wrote:
> > CAP_SYS_ADMIN is already overloaded left and right,
> > so to have more finegrained access control use
> > CAP_SYS_RESOUCE here.
> > 
> > The CAP_SYS_RESOUCE is chosen because this prctl
> > option allows a current process to adjust some
> > fields of memory map descriptor which rather
> > represent what the process owns: pointers to
> > code, data, stack segments, command line,
> > auxilary vector data and etc.
> 
> Nitpicking: s/CAP_SYS_RESOUCE/CAP_SYS_RESOURCE/ in both the commit
> summary and the commit explanation. (And if you change that you might
> also do a s/auxilary/auxiliary/ in the commit explanation.)

Oh, crap! Thanks Paul, patch was unrefreshed, while I was testing
correct version. Will update.

To Andrew: Please don't pick it up. I'll refresh and send it out
again wtih all Acks.

	Cyrill
