Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1FMXff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:35:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1FMXfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xeprjvCO58u1lS9nuKtLMHcpTf8JMQSpvomiM4G3R44Qd2cxEuMK8UtkvCV1NWNDaX
         2cLIZ608tdyJa8yA0AAkcCKhWpG5HPPKyM4DOepwJ5jk9r3tv6Fob4S9oTks8D63Xdly
         w05HHgSass0U/fRS0Vc1KlP/ow+qVfe0px8F4=
MIME-Version: 1.0
In-Reply-To: <20110609182021.73726ea3.jay.estabrook_gmail.com@gmail.com>
References: <20110609182021.73726ea3.jay.estabrook_gmail.com@gmail.com>
Date: Tue, 14 Jun 2011 09:35:30 +1000
Message-ID: <BANLkTinvXFV1bObeaym6A4VEcxv0jN+zXQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] alpha, drm: Add Alpha support to Radeon DRM code
From: Dave Airlie <airlied@gmail.com>
To: Jay Estabrook <jay.estabrook@gmail.com>
Cc: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 8:20 AM, Jay Estabrook <jay.estabrook@gmail.com> wrote:
>
> Alpha needs to have the system bus address for the device's local
> memory available, so that it can be returned to user-level, where
> it may be used in an mmap(). So, we make bus.addr hold the ioremap()
> return for kernel use, and then we can modify bus.base appropriately.
>

I don't get this. why is mmap passing in an address? we don't do that anymore.

When you mmap the device node it passes back a hashed offset in the
table, that the
kernel then translates into a proper address and sets up the page tables.

So I really don't get what this patch is doing, either the
explaination of what it is doing is wrong
or it is wrong.

Dave.
