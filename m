Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2KQXPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 18:15:19 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62048 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2KQXPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 18:15:17 -0500
Date: Fri, 16 Nov 2012 23:11:07 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Correct description of SwapFree in
 Documentation/filesystems/proc.txt
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Jim Paris <jim@jtan.com>,
        "Michael Kerrisk (gmail)" <mtk.manpages@gmail.com>
In-Reply-To: <50A5E4D6.60301@gmail.com> (from mtk.manpages@gmail.com on Fri
	Nov 16 01:01:42 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1353129067.19744.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 01:01:42 AM, Michael Kerrisk wrote:
> After migrating most of the information in
> Documentation/filesystems/proc.txt to the proc(5) man page,
> Jim Paris pointed out to me that the description of SwapFree
> in the man page seemed wrong. I think Jim is right,
> but am given pause by fact that that text has been in
> Documentation/filesystems/proc.txt since at least 2.6.0.
> Anyway, I believe that the patch below fixes things.
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

Want me to forward it on? (Lots of documentation stuff gets grabbed by  
whoever maintains what it's documenting, this looks like it might fall  
through the cracks...)

Rob
