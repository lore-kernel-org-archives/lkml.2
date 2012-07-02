Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2GBJGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:06:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54681 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2GBJGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:06:14 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <20120702085911.GA16639@n2100.arm.linux.org.uk>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org>
 <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com>
 <4FCD272E.1020300@codeaurora.org> <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
 <20120702085911.GA16639@n2100.arm.linux.org.uk>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 12:05:53 +0300
Message-ID: <CAK=WgbaV2ehq=Y2AFojG6r4HuiGQ+_hEC+azxBJDfrWEi=DTTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 11:59 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jul 02, 2012 at 11:52:27AM +0300, Ohad Ben-Cohen wrote:
>> Simplify the unregister/free interfaces, and make them easier
>> to understand and use, by moving to a symmetric and consistent
>> alloc() -> register() -> unregister() -> free() flow.
>
> The naming in the driver model is:
>
> alloc() -> add() -> del() -> put()
>
> where alloc() is an allocation + initialization, and
>
> register() -> unregister()
>
> where register() is initialization + add() and
> unregister() is del() + put().

I wasn't sure if it'd help to adopt the driver model's naming, but I
guess it just might do, so I'll do that.

Thanks!
