Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1FNL2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:28:45 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:1295 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab1FNL2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:28:44 -0400
Subject: Re: [PATCH] avr32, exec: remove redundant set_fs(USER_DS)
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1307711345-5564-1-git-send-email-minipli@googlemail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
	 <1307711345-5564-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 14 Jun 2011 13:28:06 +0200
Message-ID: <1308050886.16682.8.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2011 11:28:10.0571 (UTC) FILETIME=[240CE1B0:01CC2A86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 15:09 +0200, Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Thanks, after searching up the history before this patch I see the whole
point as well. Please drop a line/link to parent patches that explains
the whole picture in the future.

I'll apply this to the AVR32 tree.

-- 
Hans-Christian Egtvedt

