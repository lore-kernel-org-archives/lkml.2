Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2IBVhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:37:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2IBVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:37:20 -0400
Date: Sun, 2 Sep 2012 14:34:50 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Sannu K <sannumail4foss@gmail.com>
Cc: anish kumar <anish198519851985@gmail.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
Message-ID: <20120902213450.GA15196@lizard>
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>
 <CAJx5wk3URzut+zr3b1ba2oeCyVJ2OSWufwbh_NpnzpcU+C3YXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJx5wk3URzut+zr3b1ba2oeCyVJ2OSWufwbh_NpnzpcU+C3YXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 09:44:04PM +0530, Sannu K wrote: [...]
> Just Curious what is the use of this module? Is there any user space
> program uses this? When ACPI drivers for battery is available how
> useful will this be?

That's mostly for embedded devices. They often have batteries directly
connected to ADC (analog to digital converters) channels, so that's the
only way to read e.g. voltage.

As for userspace, since it's battery class driver, pretty much every
userspace stack can use it.

Thanks,
Anton.
