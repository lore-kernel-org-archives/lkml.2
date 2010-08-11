Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0HKUVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:21:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0HKUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:21:40 -0400
Message-ID: <4C630648.4050800@zytor.com>
Date: Wed, 11 Aug 2010 13:21:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: brgerst@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [resend] Re: 6175ddf06b6172046a329e3abfd9c901a43efd2e
 breaks matroxfb console
References: <201008112138.19113.linux@rainbow-software.org>
In-Reply-To: <201008112138.19113.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 12:38 PM, Ondrej Zary wrote:
> 
> Here's v2 patch:
> 

You want to send that one to the maintainer of matroxfb:

: anacreon 104 ; ./scripts/get_maintainer.pl -f
drivers/video/matrox/matroxfb_base.h
Petr Vandrovec <vandrove@vc.cvut.cz>
Andrew Morton <akpm@linux-foundation.org>
Jean Delvare <khali@linux-fr.org>
linux-fbdev@vger.kernel.org
linux-kernel@vger.kernel.org

	-hpa
