Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2B2LYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:24:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2B2LYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:24:08 -0500
Date: Wed, 29 Feb 2012 03:25:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] checkpatch.pl: be silent when -q and --ignore is
 given
Message-Id: <20120229032530.b948ee51.akpm@linux-foundation.org>
In-Reply-To: <1330513326.3545.93.camel@sauron.fi.intel.com>
References: <1330364758-12065-1-git-send-email-dedekind1@gmail.com>
	<1330513326.3545.93.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 13:02:06 +0200 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Mon, 2012-02-27 at 19:45 +0200, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <dedekind1@gmail.com>
> > 
> > This patch fixes checkpatch.pl when both -q and --ignore are given and
> > prevents it from printing a
> 
> Andrew, am I right that checkpatch.pl patches go in via your tree?

yup.

> Should I check linux-next to find out whether you have merged it or not?

I applied it, but it seems that for some reason the applied-to-mm email
didn't get sent out for that one.

