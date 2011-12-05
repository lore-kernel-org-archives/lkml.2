Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab1LEWPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:15:15 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51924 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab1LEWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <1781399.9f45Chd7K4@wuerfel>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<201112051718.48324.arnd@arndb.de>
	<CAF6AEGvyWV0DM2fjBbh-TNHiMmiLF4EQDJ6Uu0=NkopM6SXS6g@mail.gmail.com>
	<1781399.9f45Chd7K4@wuerfel>
Date: Mon, 5 Dec 2011 16:15:11 -0600
X-Google-Sender-Auth: hHWIwh5-4dRP7kE57aM2pmPVyB0
Message-ID: <CAF6AEGsiSL8x6qETm5zPaQe08=NYOD8eZsASx0e0hkjK3YEj2Q@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Rob Clark <rob@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, t.stanislaws@samsung.com,
        linux@arm.linux.org.uk, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>, m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 4:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> https://github.com/robclark/kernel-omap4/commits/dmabuf
>
> Ok, thanks. I think it would be good to post these for reference
> in v3, with a clear indication that they are not being submitted
> for discussion/inclusion yet.

btw, don't look at this too closely at that tree yet.. where the
attach/detach is done in videobuf2 code isn't really correct.  But I
was going to get something functioning first.

BR,
-R
