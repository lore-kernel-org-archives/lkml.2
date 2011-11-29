Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1K2Uro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:47:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab1K2Urn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:47:43 -0500
Date: Wed, 30 Nov 2011 00:47:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111129204735.GI1775@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <20111129203714.GH1775@moon>
 <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:40:57PM -0800, Kees Cook wrote:
> 
> Right, if you verify that the addresses are actually inside valid
> userspace vmas, that is likely to be right, though there are probably
> other things I haven't thought of. The trouble is avoiding vdso, stack
> guard page, vsyscall, and anything else that isn't meant for the mm to
> have direct access to.

Yeah, these service area should not be messed up, I'll add such tests.
Thanks a lot for comments, Kees!
