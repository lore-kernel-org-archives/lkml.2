Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965936Ab2B1STk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:19:40 -0500
Received: from antcom.de ([188.40.178.216]:47278 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2B1STj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:19:39 -0500
Message-ID: <4F4D1AB8.9060307@antcom.de>
Date: Tue, 28 Feb 2012 19:19:36 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v3] ARM: LPC32xx: USB Support
References: <1330178224-24999-1-git-send-email-stigge@antcom.de> <1330178224-24999-2-git-send-email-stigge@antcom.de> <20120228175735.GB14290@kroah.com>
In-Reply-To: <20120228175735.GB14290@kroah.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 02/28/2012 06:57 PM, Greg Kroah-Hartman wrote:
>> (This is the mach-lpc32xx specific part, the USB subsystem specific changes are
>> in a separate patch for the USB maintainers.)
> 
> Do you want/need me to take both of these?  Or just the first one?  Or,
> just ack the first one so the arm maintainers can take this one?  It's
> your choice...

The first one (actual driver) is for you to take as USB maintainer
and/or ack.

The other one is for arm-soc, and just for informational purposes for you.

Thanks in advance,

Roland
