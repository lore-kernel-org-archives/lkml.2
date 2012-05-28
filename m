Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2E1Mhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:37:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52341 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2E1Mhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120426001529.GA14006@kroah.com>
References: <20120426001529.GA14006@kroah.com>
Date: Mon, 28 May 2012 09:37:44 -0300
Message-ID: <CALF0-+UeGxjML71sWGr8A-mEwBQRyFd6fcXa2Q0VZ3dxgWPwZg@mail.gmail.com>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Apr 25, 2012 at 9:15 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This option has been deprecated for many years now, and no userspace
> tools use it anymore, so it should be safe to finally remove it.
>

Does this mean usbview will be completely deprecated?
Do you think is it possible to write an update for it?

It was a little more helpful for me than lsusb. (Is it just me?)

Thanks,
Ezequiel.
