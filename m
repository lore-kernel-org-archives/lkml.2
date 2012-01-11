Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2AKRhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:37:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49002 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2AKRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:37:07 -0500
Date: Wed, 11 Jan 2012 09:37:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 8/9] stacktrace: implement save_stack_trace_quick()
Message-ID: <20120111173700.GH26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-9-git-send-email-tj@kernel.org>
 <20120111162642.GC7991@somewhere.redhat.com>
 <20120111163826.GC26832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111163826.GC26832@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 08:38:26AM -0800, Tejun Heo wrote:
> It would be best if we can extend the existing one to cover all the
> cases with acceptable overhead.  I needed to write this minimal
> version anyway for comparison so it's posted together but no matter
> how it turns out switching them isn't difficult.

To add a bit, it would probably be better to restructure backtrace
code such that the common code provides discrete steps for backtracing
(maybe somewhat like iterators) and interface functions assembling
what they need.  Such structure would be much more malleable for
various purposes.

Thanks.

-- 
tejun
