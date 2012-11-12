Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2KLMf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:35:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47425 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2KLMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:35:25 -0500
Message-ID: <50A0ED09.6010106@suse.cz>
Date: Mon, 12 Nov 2012 13:35:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] HID: microsoft, do not use compound literal
References: <1352711769-28911-1-git-send-email-jslaby@suse.cz> <CAMuHMdUEW9K6cfpcUNphte_VzBCL_Oa_od3892DQ3QbX5xMMnA@mail.gmail.com> <alpine.LNX.2.00.1211121314270.27271@pobox.suse.cz> <CAMuHMdWq9S9oO+2OH6oiAogFR+JJxnxrtGoMp+uMm-qXCLr55A@mail.gmail.com>
In-Reply-To: <CAMuHMdWq9S9oO+2OH6oiAogFR+JJxnxrtGoMp+uMm-qXCLr55A@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 01:30 PM, Geert Uytterhoeven wrote:
> My comment was purely cosmetic, as it applies to the quoted compiler error
> messages only.

Ah, I see. When you are applying the patch Jiri, could you remove errors
about line 50 from the commit log? What I wanted to have there
apparently was only "hid-microsoft.c:51:18: error: macro "memcmp" passed
6 arguments, but takes just 3".

> Your latest version doesn't use memcmp() anymore, so I think there's no need to
> include <linux/string.h> anymore.

s/Your/His/ perhaps :). Otherwise I'd be confused -- did Jiri send some
other version?

thanks,
-- 
js
suse labs
