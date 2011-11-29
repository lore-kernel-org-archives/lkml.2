Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1K2Uzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:55:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65446 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1K2Uzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:55:53 -0500
Date: Wed, 30 Nov 2011 00:55:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111129205547.GJ1775@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <4ED54547.5060905@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED54547.5060905@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 02:49:11PM -0600, Serge Hallyn wrote:
> 
> My memory is a bit hazy here, but cryo
> (http://git.sr71.net/?p=cryo-forhallyn.git;a=summary) did also do
> this from userspace.  As I recall the one problem we had was ...
> that we couldn't lower the mm_start of the first segment?  I think.
> But I bring it up only because the advantage of doing it this way
> was that all of the ptrace protections automatically applied.
> 

Thanks for the link Serge, I'll take a look. I think for start_code
we might stick for exactly Elf path -- ie it should be vma with
at least "r-xp" prototipe as mapped by elf path (and restrictions
from Kees's mail should be applied on it as well). Other members
are not that clear for me.
