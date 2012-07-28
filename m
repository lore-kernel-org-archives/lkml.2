Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2G1OEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 10:04:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2G1OEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 10:04:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120727103241.GB14445@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-9-git-send-email-ming.lei@canonical.com>
	<20120725160425.GK11152@aftab.osrc.amd.com>
	<CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
	<20120726122016.GD30717@aftab.osrc.amd.com>
	<CACVXFVMxUKezcR5BBv6jM0wZr8UivF7dJGe1gLNiFx=1h4U59g@mail.gmail.com>
	<20120726174617.GA9161@aftab.osrc.amd.com>
	<CACVXFVOrQg56VKv22i3ydm5Vw6o=UTzDJP6-_NUiyXbD46wNhQ@mail.gmail.com>
	<20120727103241.GB14445@aftab.osrc.amd.com>
Date: Sat, 28 Jul 2012 22:04:03 +0800
Message-ID: <CACVXFVNxxbm5_Tzq-wn7AXnd6wi8Ywa91q-bgKKyy5-s_iPcRg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device lifetime
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 6:32 PM, Borislav Petkov <bp@amd64.org> wrote:

>
> I still don't like too much the "not possible to sleep for long time"
> expression.
>
> Maybe change it to "should sleep for as small periods as possible since
> it increases boot time of device drivers requesting firmware in their
> ->probe() methods."

Fairly enough, will add this kind of description in -v1, and I will introduce
one extra patch to fix this comment since it is nothing related with the
device lifetime fix and its comments.


Thanks,
--
Ming Lei
