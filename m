Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2GaKgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:36:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35648 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2GaKgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:36:50 -0400
MIME-Version: 1.0
In-Reply-To: <201207251331.52883.arnd@arndb.de>
References: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com>
	<CANKRQni4SU=876iPtHJ2WC3Ub7QProJqHZ53Ru-n-njsdg8D5A@mail.gmail.com>
	<CANKRQnhcFr+e1H5p==UUTWfYb2nzdt8aVnOn2NvmYAXFiDxqew@mail.gmail.com>
	<201207251331.52883.arnd@arndb.de>
Date: Tue, 31 Jul 2012 19:36:49 +0900
Message-ID: <CANKRQnimtFQapk-u_ipYYOqrVVavGBCqcAG6x82WNWCH_Jcdkw@mail.gmail.com>
Subject: Re: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> What I think should work better here would be to use the clk API,
> so that the phub driver registers a 'struct clk' using
> (I assume) clk_register_divider_table().
> The UART driver would then call clk_get() to find that clk for
> the uart device and call clk_set_rate when it needs to change
> that clock in order to set a different baud rate.
>
> Does this make sense?
>

Thank you for your comments. This sounds good idea.
However, it seems the latest kernel doesn't have clk_register_divider_table().
Will the clk_register_divider_table function be applied soon ?

Thanks.

-- 
ROHM Co., Ltd.
tomoya
