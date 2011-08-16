Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1HPFmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:42:13 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33730 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1HPFmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <1313454275-5604-3-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
	<1313454275-5604-3-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 08:42:11 +0300
X-Google-Sender-Auth: qUpJ1CgAlKWArNOxuqz2jkVpyDk
Message-ID: <CAOJsxLHesFg3BsBeUO481m1=H87RROUzKtgjZOD9Scxjn-KOWA@mail.gmail.com>
Subject: Re: [PATCH 3/9] Staging: Winbond: Fix space issues in wb35tx.c.
From: Pekka Enberg <penberg@kernel.org>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:24 AM, Akshay Joshi <me@akshayjoshi.com> wrote:
> Issues with spaces (such as not having spaces inside of square brackets,
> etc.) were fixed in the wb35tx.c file.
>
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
