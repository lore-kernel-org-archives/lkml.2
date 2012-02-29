Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031204Ab2B2Pbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:31:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65042 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031177Ab2B2Pbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:31:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.130.13 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Wed, 29 Feb 2012 19:31:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120229153132.GG11326@moon>
References: <20120229151634.GE4796@moon>
 <4F4E42DB.2030507@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E42DB.2030507@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 07:23:07PM +0400, Pavel Emelyanov wrote:
> On 02/29/2012 07:16 PM, Cyrill Gorcunov wrote:
> > Hi guys,
> > 
> > at restore time we would like to have a way for /proc/pid/exe
> > symlink recovering. So I thought extending prctl might be
> > a good idea.
> > 
> > Still maybe there some other good and 'right' way to do it,
> > so I would like to gather opinions.
> 
> If using the prctl for this, then taking a given file descriptor
> (with fcheck) instead of taking path and opening it in kernel is
> better.
> 

Sounds like a plan. Thanks Pavel!

	Cyrill
