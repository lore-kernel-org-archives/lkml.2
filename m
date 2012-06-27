Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2F0Oj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:39:56 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48908 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab2F0Ojy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:39:54 -0400
Date: Wed, 27 Jun 2012 16:39:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8 v3] i2c: i801: refactor use of LAST_BYTE
 i801_block_transaction_byte_by_byte
Message-ID: <20120627163929.4305eaa7@endymion.delvare>
In-Reply-To: <1340805255-8041-2-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-2-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:54:08 +0800, Daniel Kurtz wrote:
> As a slight optimization, pull some logic out of the polling loop during
> byte-by-byte transactions by just setting the I801_LAST_BYTE bit, as
> defined in the i801 (PCH) datasheet, when reading the last byte of a
> byte-by-byte I2C_SMBUS_READ.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> (...)

Applied, thanks.

-- 
Jean Delvare
