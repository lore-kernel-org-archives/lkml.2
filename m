Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2DIPYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:24:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35010 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2DIPYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <8762d9v10x.fsf@turtle.gmx.de>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <8762d9v10x.fsf@turtle.gmx.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Apr 2012 08:24:15 -0700
X-Google-Sender-Auth: d-7X5hdZbe9jQlzPVWZVETK0Rpw
Message-ID: <CA+55aFy9TKbVEOsBCWUf4u3o5qojvLLj6bEV-fNqdK3_1ysp1w@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: Sven Joachim <svenjoac@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 12:04 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>
> While I did not experience any crashes or instabilities (yet?), I'm also
> seeing memory leaks.  On a system started this morning, with hardly
> anything running:

Do you also have ANDROID support compiled in?  And
ANDROID_LOW_MEMORY_KILLER in particular?

                  Linus
