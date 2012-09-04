Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2IDPFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:05:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55506 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2IDPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:05:39 -0400
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
From: anish kumar <anish198519851985@gmail.com>
Cc: Sannu K <sannumail4foss@gmail.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
In-Reply-To: <20120902213450.GA15196@lizard>
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>
	 <CAJx5wk3URzut+zr3b1ba2oeCyVJ2OSWufwbh_NpnzpcU+C3YXA@mail.gmail.com>
	 <20120902213450.GA15196@lizard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Sep 2012 20:35:22 +0530
Message-ID: <1346771122.6243.6.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-02 at 14:34 -0700, Anton Vorontsov wrote:
> On Sun, Sep 02, 2012 at 09:44:04PM +0530, Sannu K wrote: [...]
> > Just Curious what is the use of this module? Is there any user space
> > program uses this? When ACPI drivers for battery is available how
> > useful will this be?
> 
> That's mostly for embedded devices. They often have batteries directly
> connected to ADC (analog to digital converters) channels, so that's the
> only way to read e.g. voltage.
> 
> As for userspace, since it's battery class driver, pretty much every
> userspace stack can use it.
Can I get some review comments on this?
> 
> Thanks,
> Anton.


