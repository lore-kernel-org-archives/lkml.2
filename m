Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2F1HFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:05:09 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3433 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2F1HFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:05:07 -0400
Date: Thu, 28 Jun 2012 09:04:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8 v3] i2c: i801: drop ENABLE_INT9
Message-ID: <20120628090436.56ceed17@endymion.delvare>
In-Reply-To: <1340805255-8041-7-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-7-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:54:13 +0800, Daniel Kurtz wrote:
> Later patches enable interrupts.  This preliminary patch removes the older
> unsupported ENABLE_INT9 flag.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> (...)

Applied, thanks.

-- 
Jean Delvare
