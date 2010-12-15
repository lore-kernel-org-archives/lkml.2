Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0LOWGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:06:07 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:34817 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0LOWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GjhrdlwPGq3+DT22rzj9l0WHCjf/osfqC3h/cn12pxKy9l3yz9uDAaPUsEMcsYv+96
         4pFBKPodhfIO3MIoc3AkHoKQnxGpsOsiYYFPiEWn4bfVHbaabonSD1d4B2tgweGEWOM3
         CZCxt+L1Fpo4qfJMFP79X0E33pM9DgQsDH6bU=
MIME-Version: 1.0
In-Reply-To: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
Date: Thu, 16 Dec 2010 00:06:03 +0200
Message-ID: <AANLkTikuWubUkGp2nESWTLz+kQsczznh7fuixdLzMfdO@mail.gmail.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:00 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> Currently only drivers that are built as modules have their versions
> shown in /sys/module/<module_name>/version, but this information might

Can you create just /sys/module/x?
Module version info is quite useless by itself.
