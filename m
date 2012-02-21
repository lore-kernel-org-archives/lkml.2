Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2BUTFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:05:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36828 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2BUTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:05:47 -0500
Date: Tue, 21 Feb 2012 17:05:25 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/30] compat: Use COMPAT_USE_64BIT_TIME in the Bluetooth
 subsystem
Message-ID: <20120221190419.GA2914@joana>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, hjl.tools@gmail.com,
	Marcel Holtmann <marcel@holtmann.org>,
	"David S. Miller" <davem@davemloft.net>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
 <1329696488-16970-11-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329696488-16970-11-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> [2012-02-19 16:07:48 -0800]:

> From: "H. J. Lu" <hjl.tools@gmail.com>
> 
> Enable the Bluetooth subsystem to be used with a compat ABI with
> 64-bit time.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo F. Padovan <padovan@profusion.mobi>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/bluetooth/hci_sock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.

	Gustavo
