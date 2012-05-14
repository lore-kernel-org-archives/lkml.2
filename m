Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2ENR1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:27:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58111 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2ENR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:27:17 -0400
Message-ID: <4FB1402A.4020609@mvista.com>
Date: Mon, 14 May 2012 21:26:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
CC: Greg KH <gregkh@linuxfoundation.org>, Reinhard Tartler <tartler@cs.fau.de>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] usb: musb: cppi: add missing include to fix compilation
References: <1337011520-15286-1-git-send-email-tartler@cs.fau.de> <20120514163154.GA17555@kroah.com> <87ipfyemb8.fsf@faui43f.informatik.uni-erlangen.de>
In-Reply-To: <87ipfyemb8.fsf@faui43f.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/14/2012 08:53 PM, Reinhard Tartler wrote:

>> On Mon, May 14, 2012 at 06:05:20PM +0200, Reinhard Tartler wrote:
>>> This fixes compilation as module.

>>> Signed-off-by: Reinhard Tartler<tartler@cs.fau.de>
>>> ---
>>>   drivers/usb/musb/cppi_dma.c |    1 +
>>>   1 file changed, 1 insertion(+)

>>> This patch was found by tools developed in the VAMOS project:
>>> http://www4.cs.fau.de/Research/VAMOS/

>> Does that mean that no one actually can hit this in "real life"?  Or is
>> there a valid .config that this solves a problem for?  If so, is it also
>> needed for the 3.4/3.3-stable tree and older ones?

> My tool has generated the attached configuration that exposes this
> compilation failure. I have used kernel v3.2 with Ubuntu's arm
> cross-compiler for the analysis and verification.

    Strange, your .config indicated that DMA driver and MUSB driver into which 
it is linked are build monolithic. You also should use 3.3 series kernel.

> Cheers,
> Reinhard

WBR, Sergei

