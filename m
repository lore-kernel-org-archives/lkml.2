Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1BANJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:09:36 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30488 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1BANJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:09:35 -0500
Date: Tue, 1 Feb 2011 14:09:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, mchehab@redhat.com, d.belimov@gmail.com,
        stefan.ringel@arcor.de, michel.ludwig@gmail.com,
        c.pascoe@itee.uq.edu.au, ruslan@rpisarev.org.ua,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: tm6000: fixed some coding style issues
Message-ID: <20110201140913.491912fd@endymion.delvare>
In-Reply-To: <1296564547-26619-1-git-send-email-tvh@informatik.uni-kiel.de>
References: <1296564547-26619-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Feb 2011 13:49:07 +0100, Timo von Holtz wrote:
> Fixed all of the following coding style issues:
> 
> ERROR: return is not a function, parentheses are not required
> WARNING: __func__ should be used instead of gcc specific __FUNCTION__
> ERROR: trailing whitespace
> ERROR: spaces required around that '=' (ctx:VxV)
> WARNING: please, no space before tabs
> WARNING: please, no spaces at the start of a line
> ERROR: space required after that ',' (ctx:VxV)
> WARNING: space prohibited between function name and open parenthesis '('
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: spaces required around that '==' (ctx:VxV)
> 
> Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>

Acked-by: Jean Delvare <khali@linux-fr.org>

Thanks, Timo.

-- 
Jean Delvare
