Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2KLOqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:46:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2KLOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:46:23 -0500
Date: Mon, 12 Nov 2012 15:46:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] HID: microsoft, do not use compound literal
In-Reply-To: <50A0ED09.6010106@suse.cz>
Message-ID: <alpine.LNX.2.00.1211121535370.15877@pobox.suse.cz>
References: <1352711769-28911-1-git-send-email-jslaby@suse.cz> <CAMuHMdUEW9K6cfpcUNphte_VzBCL_Oa_od3892DQ3QbX5xMMnA@mail.gmail.com> <alpine.LNX.2.00.1211121314270.27271@pobox.suse.cz> <CAMuHMdWq9S9oO+2OH6oiAogFR+JJxnxrtGoMp+uMm-qXCLr55A@mail.gmail.com>
 <50A0ED09.6010106@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Jiri Slaby wrote:

> > My comment was purely cosmetic, as it applies to the quoted compiler error
> > messages only.
> 
> Ah, I see. When you are applying the patch Jiri, could you remove errors
> about line 50 from the commit log? What I wanted to have there
> apparently was only "hid-microsoft.c:51:18: error: macro "memcmp" passed
> 6 arguments, but takes just 3".

Thanks. I have removed the misleading build failures from the changelog 
and applied.

-- 
Jiri Kosina
SUSE Labs
