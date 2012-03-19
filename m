Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2CSIbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:31:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2CSIbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120315154323.GB23589@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com> <20120315154323.GB23589@kroah.com>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 19 Mar 2012 14:00:42 +0530
X-Google-Sender-Auth: ohZI2kyA6iadOg_x_KrLyboQfkA
Message-ID: <CAH+eYFCCmzpitGp7PBsJB1_H5yR6A5bKqV60pVxATU8pgDrvVg@mail.gmail.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 21:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>
>> If !dev->class, device_move() does not respect the dpm_order.
>> Fix it to do so.
>
> Is there code today in the kernel that needs this to go in now?  For
> older releases?  Or is 3.4 acceptable?

I did not notice any problems with current users.  3.4 should
therefore be OK.
