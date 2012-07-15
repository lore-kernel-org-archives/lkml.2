Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2GOJNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:13:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52547 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GOJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:12:56 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <4FF5FA9B.4070003@codeaurora.org>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <4FC5DBFA.2030300@codeaurora.org> <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com>
 <CAK=WgbbREXV8nkF4vh9iLUp1WQj2ZLYW6VG8Urmw9=roy63meQ@mail.gmail.com>
 <4FF1F145.2050408@codeaurora.org> <CAK=WgbZ+=MGU5juuOP+_vtUe4d_46j=Rd0cqYi7q2i-9T35R5w@mail.gmail.com>
 <4FF5FA9B.4070003@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 12:12:35 +0300
Message-ID: <CAK=WgbbTh8C4_qZRnFe0gqoTETRb+KfMVe78L6LC3bZsFh80Sw@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each rproc
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:35 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Ok then. Please add
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Added, and applied patch. thanks!

> It would be nice if you got an ack from Greg or Kay on the device_type
> usage too.

I agree, I'd just hate bothering them on this now. Probably a topic
for a conference chat :)
