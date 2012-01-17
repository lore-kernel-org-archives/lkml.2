Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2AQNch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:32:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42737 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2AQNcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:32:35 -0500
MIME-Version: 1.0
In-Reply-To: <5b429d6c4d0a3ad06ec01193eab7edc98a03e0de.1326803859.git.leonid.moiseichuk@nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
	<5b429d6c4d0a3ad06ec01193eab7edc98a03e0de.1326803859.git.leonid.moiseichuk@nokia.com>
Date: Tue, 17 Jan 2012 15:32:35 +0200
X-Google-Sender-Auth: vtfysn9Yc0q7ytACn6ZZK6tUdRs
Message-ID: <CAOJsxLFCbF8azY48_SHhYQ0oRDrf2-rEvGMKHBne2Znpj0XL4g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Memory notification pseudo-device module
From: Pekka Enberg <penberg@kernel.org>
To: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        gregkh@suse.de, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 3:22 PM, Leonid Moiseichuk
<leonid.moiseichuk@nokia.com> wrote:
> The memory notification (memnotify) device tracks level of memory utilization,
> active page set and notifies subscribed processes when consumption crossed
> specified threshold(s) up or down. It could be used on embedded devices to
> implementation of performance-cheap memory reacting by using
> e.g. libmemnotify or similar user-space component.
>
> The minimal (250 ms) and maximal (15s) periods of reaction and granularity
> (~1.4% of memory size) could be tuned using module options.
>
> Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>

Is the point of making this a misc device to keep the ABI compatible
with N9? Is the ABI documented?

                        Pekka
