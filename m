Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0LWWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:14:27 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:18420 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0LWWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:14:26 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 17:14:25 EST
Message-ID: <4D13C7E8.4020007@free.fr>
Date: Thu, 23 Dec 2010 23:06:32 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Iceowl/1.0b2 Icedove/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: lud <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
References: <4D131C9A.4020503@Free.fr> <20101223140226.04479f6a.rdunlap@xenotime.net>
In-Reply-To: <20101223140226.04479f6a.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/2010 23:02, Randy Dunlap wrote:
> [add linux-usb list]

Note that after making
	make O=buildir mrproper; make mproper and rebuilding

I still have the hang after the "Will now halt", but no more the usb 
message.

--eric
