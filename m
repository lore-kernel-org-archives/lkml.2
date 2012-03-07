Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2CGUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:35:46 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:4000 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab2CGUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:35:43 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 15:35:43 EST
Message-ID: <1331152168.1798.13.camel@x61.thuisdomein>
Subject: Re: [PATCH] prctl: Use CAP_SYS_RESOUCE for PR_SET_MM option
From: Paul Bolle <pebolle@tiscali.nl>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>
Date: Wed, 07 Mar 2012 21:29:28 +0100
In-Reply-To: <20120307125217.GC20558@moon>
References: <20120307125217.GC20558@moon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 Mar 2012 20:29:29.0150 (UTC) FILETIME=[FF15FDE0:01CCFCA0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 16:52 +0400, Cyrill Gorcunov wrote:
> CAP_SYS_ADMIN is already overloaded left and right,
> so to have more finegrained access control use
> CAP_SYS_RESOUCE here.
> 
> The CAP_SYS_RESOUCE is chosen because this prctl
> option allows a current process to adjust some
> fields of memory map descriptor which rather
> represent what the process owns: pointers to
> code, data, stack segments, command line,
> auxilary vector data and etc.

Nitpicking: s/CAP_SYS_RESOUCE/CAP_SYS_RESOURCE/ in both the commit
summary and the commit explanation. (And if you change that you might
also do a s/auxilary/auxiliary/ in the commit explanation.)


Paul Bolle

