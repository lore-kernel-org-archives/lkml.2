Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0DSVyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:54:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41304 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0DSVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:54:04 -0400
Date: Mon, 19 Apr 2010 22:54:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexander Samad <alex@samad.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: problem with gobi loader on HP mini 5101
Message-ID: <20100419215400.GA20921@srcf.ucam.org>
References: <r2l836a6dcf1004191348tba6a2b5al8051a65e5c6f81fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2l836a6dcf1004191348tba6a2b5al8051a65e5c6f81fd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:48:06AM +1000, Alexander Samad wrote:

> I am not sure what or how to debug this, so I have come to the list.
> running debian i386 2.6.32-4

The switch to kfifo in usbserial in .32 broke it. There are patches on 
linux-usb, but they won't apply cleanly to .32.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
