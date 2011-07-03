Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1GCIUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:20:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39021 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1GCIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 3 Jul 2011 10:19:55 +0200
X-Google-Sender-Auth: jioVZfoJJPxFHfXVx0837v6shYE
Message-ID: <CAO+b5-p26Ch73DeZR4OMmvbxsVuP0j6t2Htjsae24NeqhspHtw@mail.gmail.com>
Subject: Re: [PATCH 0/11] dynamic_debug: allow multiple pending queries on boot-line
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> This patchset extends dynamic-debug facility to allow
> use of pr_debug() within a loadable module's module_init()
> function.

Can you please clean up checkpatch complaints before resubmitting ?
This is what checkpatch reports on the current patch set:

ERROR: code indent should use tabs where possible
#125: FILE: lib/dynamic_debug.c:119:
+        sprintf(prbuf_query,$

WARNING: please, no spaces at the start of a line
#125: FILE: lib/dynamic_debug.c:119:
+        sprintf(prbuf_query,$

ERROR: code indent should use tabs where possible
#211: FILE: lib/dynamic_debug.c:357:
+        sprintf(prbuf_query,$

WARNING: please, no spaces at the start of a line
#211: FILE: lib/dynamic_debug.c:357:
+        sprintf(prbuf_query,$

ERROR: trailing whitespace
#442: FILE: lib/dynamic_debug.c:756:
+^I^I^I$

ERROR: trailing whitespace
#469: FILE: lib/dynamic_debug.c:813:
+^I^I$

ERROR: else should follow close brace '}'
#483: FILE: lib/dynamic_debug.c:827:
+               }
+               else if (verbose)

Thanks,

Bart.
