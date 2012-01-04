Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2ADUnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:43:02 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54762 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab2ADUm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:42:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F04B3F0.6080103@redhat.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
	<20120104195612.GB19181@suse.de>
	<4F04B3F0.6080103@redhat.com>
Date: Wed, 4 Jan 2012 22:42:58 +0200
X-Google-Sender-Auth: 6CGLOCoZjNCFcSCkZAtcICMShg4
Message-ID: <CAOJsxLH8s5cjUSdpBpLNDvtNaJjnhBwNKOMXZPzUD=XDivr7Rg@mail.gmail.com>
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related
 changes in MM
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com, Minchan Kim <minchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 10:17 PM, Rik van Riel <riel@redhat.com> wrote:
> Also, the low memory notification that Kosaki-san has worked on,
> and which Minchan is looking at now.
>
> We seem to have many mechanisms under development, all aimed at
> similar goals. I believe it would be good to agree on one mechanism
> that could solve multiple of these goals at once, instead of sticking
> a handful of different partial solutions in the kernel...

And even if people want to support multiple ABIs and fight it out to
see which one wins, we should factor out the generic parts and put
them under mm/*.c and not hide them in random modules.

                        Pekka
