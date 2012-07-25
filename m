Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2GYAUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:20:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49746 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GYAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:20:50 -0400
Date: Tue, 24 Jul 2012 21:20:42 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Masatake YAMATO <yamato@redhat.com>
Cc: andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v3 2/8] bluetooth: Added /proc/net/bnep via
 bt_procfs_init()
Message-ID: <20120725002042.GQ20029@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Masatake YAMATO <yamato@redhat.com>,
	andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120629.020253.963694178693689545.yamato@redhat.com>
 <20120710140400.GA15795@aemeltch-MOBL1>
 <20120711.135831.1712662939552441872.yamato@redhat.com>
 <20120711.135935.132280748714890089.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711.135935.132280748714890089.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

* Masatake YAMATO <yamato@redhat.com> [2012-07-11 13:59:35 +0900]:

> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  net/bluetooth/bnep/sock.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)

For the rest of the series I'd like you add some commit message to your patch,
only a commit title is not acceptable, even if in a simple patch. Also use
"Bluetooth" and not "bluetooth" in the subject line please.

	Gustavo
