Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0DTDTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:19:40 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:33010 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0DTDTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100419215400.GA20921@srcf.ucam.org>
References: <r2l836a6dcf1004191348tba6a2b5al8051a65e5c6f81fd@mail.gmail.com>
	 <20100419215400.GA20921@srcf.ucam.org>
Date: Tue, 20 Apr 2010 13:19:35 +1000
Message-ID: <v2p836a6dcf1004192019r48dfa8f4g4492c98afff48552@mail.gmail.com>
Subject: Re: problem with gobi loader on HP mini 5101
From: Alexander Samad <alex@samad.com.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 7:54 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Apr 20, 2010 at 06:48:06AM +1000, Alexander Samad wrote:
>
>> I am not sure what or how to debug this, so I have come to the list.
>> running debian i386 2.6.32-4
>
> The switch to kfifo in usbserial in .32 broke it. There are patches on
> linux-usb, but they won't apply cleanly to .32.

so .33 or .34 are okay ?

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>
