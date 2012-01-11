Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2AKRGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:06:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59292 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2AKRGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:06:41 -0500
Date: Wed, 11 Jan 2012 09:06:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>, namhyung@gmail.com
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
Message-ID: <20120111170635.GE26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-10-git-send-email-tj@kernel.org>
 <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F0D291A.8030205@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0D291A.8030205@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 03:15:54PM +0900, Namhyung Kim wrote:
> How about adding another tracepoint for intent creation to provide
> raw data as well, somewhere in iob_get_intent() or
> iob_intent_create() maybe? It can be useful to get those data for
> further processing IMHO.

While I don't particularly object to that, information and
notification (via inotify) for that is already available via
ioblame/intents file which we need regardless of the new tracepoint,
so it's kinda redundant, isn't it?

Thanks.

-- 
tejun
