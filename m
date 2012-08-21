Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2HUQnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:43:16 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4035 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758059Ab2HUQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:43:14 -0400
Message-ID: <1345567392.4564.30.camel@x61.thuisdomein>
Subject: Re: [PATCH] serial: Remove orphaned header sc26198.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Date: Tue, 21 Aug 2012 18:43:12 +0200
In-Reply-To: <1345564193-25994-1-git-send-email-shc_work@mail.ru>
References: <1345564193-25994-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Aug 2012 16:43:12.0687 (UTC) FILETIME=[0DDE63F0:01CD7FBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 19:49 +0400, Alexander Shiyan wrote:
> This header was used by the driver "stallion", but the driver has
> been removed as a result of migration 2.4 -> 2.6 and the header is
> still present in the system and is not currently used by any driver.
> We can safely remove it.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  include/linux/sc26198.h |  533 -----------------------------------------------

commit afbaade3dc99838a0c39699bea175674f27322a1 ("delete seven tty
headers"), in - I think - tty.git's tty-next branch, already deleted
this and six other headers.

>  1 files changed, 0 insertions(+), 533 deletions(-)
>  delete mode 100644 include/linux/sc26198.h


Paul Bolle

