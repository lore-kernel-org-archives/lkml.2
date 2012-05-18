Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab2ERQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:46:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965260Ab2ERQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
 <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
 <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
 <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com> <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 May 2012 09:46:10 -0700
X-Google-Sender-Auth: mDpgXN-4IciZ4dR40O3A11AyQNQ
Message-ID: <CA+55aFxs1vcU08=7tEhmKRSRvjw5rUAqKfgWFPyta_qx7J7cog@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, having thought it over some more, I decided to do the pull.

I still think MCE is confusing and actively buggy in many respects,
and your RIPV check is much much too late, but with your patch it's no
worse than it used to be.

                       Linus
