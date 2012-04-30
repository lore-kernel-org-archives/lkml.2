Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2D3GtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:49:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2D3GtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:49:12 -0400
Message-ID: <4F9E35BC.5000200@zytor.com>
Date: Sun, 29 Apr 2012 23:48:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Kent <raven@themaw.net>,
        Thomas Meyer <thomas@m3y3r.de>, autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <4F9E30BF.4030704@msgid.tls.msk.ru> <4F9E3474.2050405@msgid.tls.msk.ru>
In-Reply-To: <4F9E3474.2050405@msgid.tls.msk.ru>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 11:43 PM, Michael Tokarev wrote:
> 
> I think this is a false alarm.  I checked autofs v3 and v4
> userspace code (found on  http://www.kernel.org/pub/linux/daemons/autofs )
> and they both read whole packet at once, not piece-wise.
> 

Yup, the original braindamage is all mine.

	-hpa

