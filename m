Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2HTILh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:11:37 -0400
Received: from antcom.de ([188.40.178.216]:60073 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2HTILf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:11:35 -0400
Message-ID: <5031F12F.5050201@antcom.de>
Date: Mon, 20 Aug 2012 10:11:27 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <502E11F7.4080300@linutronix.de> <5030DD33.7040804@antcom.de> <5031E228.80403@linutronix.de>
In-Reply-To: <5031E228.80403@linutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/20/2012 09:07 AM, Sebastian Andrzej Siewior wrote:
>> I merged these changes into the patch set, and will repost it tomorrow
>> after I can test it more thoroughly.
> 
> Thanks.
> While you are playing with it, I saw that you handle vbus (->pull())
> manually. This was the case in the "old" start/stop case but in the new
> one, the udc-core is / should handle it.

I included the respective changes into my patch set that I'm posting
separately now.

Thanks for the note,

Roland
