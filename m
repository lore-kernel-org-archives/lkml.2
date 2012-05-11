Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2EKHsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:48:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39980 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2EKHsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com>
References: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com>
Date: Fri, 11 May 2012 09:48:45 +0200
Message-ID: <CACRpkdZZmxqus6jujtq43qD_d_dHxi2wORmC18kGsD3aB1jjAQ@mail.gmail.com>
Subject: Re: gpio: pca953x: interrupt feature unreliable (re-re-send, Grant
 please acknowledge!!)
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        David Jander <david@protonic.nl>
Cc: Grant Likely <grant.likely@secretlab.ca>, linus.walleij@stericsson.com,
        torvalds@linux-foundation.org,
        open list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, eric.miao@marvell.com,
        maz@misterjones.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 8:19 PM, Jean-Francois Dagenais
<jeff.dagenais@gmail.com> wrote:

> I would propose a patch, but I am missing knowledge on the internals of the
> kernel's irq code, so here's a simple suggestion description, hoping to get
> some feedback.

David Jander has been working on this driver lately, David can you have a
look at the quite complex description from Jean-Francois?

Yours,
Linus Walleij
