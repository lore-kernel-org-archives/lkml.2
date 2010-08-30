Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0H3VjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:39:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51712 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0H3VjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MubZWg1b/NJvb2ejSG2SrNFN9jA9+JDyF9P0weTRqe9PFvrfsqRRrrk5/PNgEhs7Cm
         1inbqW9upcWR1te5sIxk75Wk86dP1bW4r/xQnUE+cSm+5oa4tDX4+l6nhLwsyulnwBVK
         a04IWD0Hq3HZKGr9oVReIrhXb/rzjJj+3oxLg=
Message-ID: <4C7C24ED.5070501@suse.cz>
Date: Mon, 30 Aug 2010 23:38:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100830184737.GA21339@suse.de> <201008302333.22447.arnd@arndb.de>
In-Reply-To: <201008302333.22447.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 11:33 PM, Arnd Bergmann wrote:
> With the feedback I have so far, I think we have
> 
> drivers/char/tty_*      -> tty/*
> drivers/char/{vt stuff} -> tty/vt/
> drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> drivers/serial/*        -> drivers/tty/serial/*
> drivers/usb/serial      -> drivers/usb/serial
> 
> cyclades,moxa,mxser     -> drivers/tty/hw/

I wouldn't go for hw subdir. IMHO 'drivers' is enough.

> amiserial,nozomi,
> serial167,synclink      -> drivers/tty/hw (?)

Yeah, sorry I forgot about nozomi. It is used by some 3G cards or
anything currently. It was added only few years ago and people report
bugs against that too :), so is in use.

regards,
-- 
js
suse labs
