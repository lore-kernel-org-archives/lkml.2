Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2DJKvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:51:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56111 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2DJKvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120315154323.GB23589@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
	<20120315154323.GB23589@kroah.com>
Date: Tue, 10 Apr 2012 12:51:35 +0200
Message-ID: <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 4:43 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>
>> If !dev->class, device_move() does not respect the dpm_order.
>> Fix it to do so.
>
> Is there code today in the kernel that needs this to go in now?  For
> older releases?  Or is 3.4 acceptable?

To me it seems it has not been merged to 3.4 yet ... can we have it
for the -rc:s?

Yours,
Linus Walleij
