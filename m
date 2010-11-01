Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0KAITU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:19:20 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:38321 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KAITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:19:17 -0400
Subject: Re: [PATCH 1/6] avr32: missed _TIF_NOTIFY_RESUME on one of
 do_notify_resume callers
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QNe-0008Rr-Vf@ZenIV.linux.org.uk>
References: <E1P0QNe-0008Rr-Vf@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 08:55:57 +0100
Message-ID: <1288598157.2843.9.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 07:55:58.0311 (UTC) FILETIME=[38166F70:01CB799A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:57 +0100, Al Viro wrote: 
> we need that not just on syscall returns but on irq ones as well...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

