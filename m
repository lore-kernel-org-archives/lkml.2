Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2ITWCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:02:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2ITWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:02:04 -0400
Date: Thu, 20 Sep 2012 14:59:27 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sbs-battery: probe should try talking to the device
Message-ID: <20120920215926.GD18223@lizard>
References: <1346956349-21980-1-git-send-email-olof@lixom.net>
 <5048ECF2.8050307@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5048ECF2.8050307@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 02:35:30PM -0400, Rhyland Klein wrote:
> On 09/06/2012 02:32 PM, Olof Johansson wrote:
> >Turns out this driver doesn't actually try talking to the device at
> >probe time, so if it's incorrectly configured in the device tree or
> >platform data (or if the battery has been removed from the system), then
> >probe will succeed and every access will sit there and time out. The
> >end result is a possibly laggy system that thinks it has a battery but
> >can never read status, which isn't very useful.
> >
> >Instead, just read any register (I chose status) at probe, and if that
> >fails, don't register the device.
> >
> >Signed-off-by: Olof Johansson <olof@lixom.net>
[...]
> Acked-by: Rhyland Klein <rklein@nvidia.com>

Applied, thank you folks!
