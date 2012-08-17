Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab2HQPgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:36:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:50796 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab2HQPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:36:34 -0400
Message-ID: <502E64FD.4090100@linutronix.de>
Date: Fri, 17 Aug 2012 17:36:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] scripts/modpost: add a exception for USB gadget drivers
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de> <1345060759-18091-3-git-send-email-bigeasy@linutronix.de> <20120815201426.GA6902@merkur.ravnborg.org>
In-Reply-To: <20120815201426.GA6902@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:14 PM, Sam Ravnborg wrote:
> Could you use the __ref / __refdata annotation?
> This would be much cleaner than this hack in modpost.

Hmmm.

$ git grep " __init " drivers/usb/gadget/ | grep -vE 
'[_-]udc\.c|net22..\.c|udc-core\.c|dummy_hcd' | wc -l
71

That is the number of annotations I would have to change temporary. I
would prefer to avoid it but if you say no then I guess I have to do it.

>
> 	Sam

Sebastian
