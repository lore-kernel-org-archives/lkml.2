Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0KAIaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:30:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:33598 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0KAIaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:30:13 -0400
Subject: Re: [PATCH 5/6] avr32: need to reset ->restart_block.fn on
 sigreturn
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QOJ-0008Sx-0W@ZenIV.linux.org.uk>
References: <E1P0QOJ-0008Sx-0W@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 09:30:00 +0100
Message-ID: <1288600200.2843.24.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 08:30:01.0069 (UTC) FILETIME=[F9AA91D0:01CB799E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:58 +0100, Al Viro wrote: 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

