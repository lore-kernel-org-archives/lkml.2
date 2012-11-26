Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2KZFuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:50:10 -0500
Received: from shmail0.sohard.de ([212.114.139.117]:52277 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2KZFuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:50:08 -0500
Date: Mon, 26 Nov 2012 06:50:05 +0100 (CET)
From: Rene Buergel <rene.buergel@sohard.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ezusb: add dependency to USB
Message-ID: <236da397-07bc-4347-8722-2ac82c52c672@shmail0>
In-Reply-To: <20121122182744.GA25505@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [194.138.39.62]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Ursprüngliche Mail -----
> On Thu, Nov 22, 2012 at 07:10:50PM +0100, Rene Buergel wrote:
> > This fixes an error during modpost, when ezusb is built into the
> > kernel while USB is built as module.
> thanks for the fix, I'll queue it up for 3.8
> and
> backport it for 3.7-stable as well.
> 
> thanks,
> 
> greg k-h
> 

you're welcome,

René Bürgel
