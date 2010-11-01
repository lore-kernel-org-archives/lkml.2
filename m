Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0KAIVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:21:02 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:32861 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab0KAIU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:20:59 -0400
Subject: Re: [PATCH 4/6] avr32: clear TIF_RESTORE_SIGMASK when signal is
 delivered
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QO9-0008So-06@ZenIV.linux.org.uk>
References: <E1P0QO9-0008So-06@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 09:20:46 +0100
Message-ID: <1288599646.2843.23.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 08:20:47.0105 (UTC) FILETIME=[AF7A5F10:01CB799D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:57 +0100, Al Viro wrote: 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

