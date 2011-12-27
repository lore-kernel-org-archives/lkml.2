Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1L0VzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:55:05 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:42338 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1L0VzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:55:04 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/usb/class/cdc-acm.c: clear dangling pointer
Date: Tue, 27 Dec 2011 22:56:39 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.name>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1324645375-3535-1-git-send-email-julia@diku.dk>
In-Reply-To: <1324645375-3535-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112272256.39617.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 23. Dezember 2011, 14:02:55 schrieb Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> On some failures, the country_code field of an acm structure is freed
> without freeing the acm structure itself.  Elsewhere, operations including
> memcpy and kfree are performed on the country_code field.  The patch sets
> the country_code field to NULL when it is freed, and likewise sets the
> country_code_size field to 0.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Oliver NEukum <oneukum@suse.de>

This is in principle oopsable and should go into stable.

	Regards
		Oliver
