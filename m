Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2APN23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:28:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2APN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:28:18 -0500
Message-ID: <4F1425EB.6050703@gmail.com>
Date: Mon, 16 Jan 2012 14:28:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120106 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, Arnd Bergmann <arnd@arndb.de>,
        alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, "3.0 3.1 3.2" <stable@vger.kernel.org>
Subject: Re: [PATCH] TTY: fix UV serial console regression
References: <4EDE988B.6010501@suse.cz> <1326405315-6601-1-git-send-email-jslaby@suse.cz> <20120112234132.0a973cb9@pyramind.ukuu.org.uk>
In-Reply-To: <20120112234132.0a973cb9@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 12:41 AM, Alan Cox wrote:
>> Unless there is some bad race in the code, the hardware seems to
>> be pretty broken. Otherwise pure MSR read should not cause such a
>> bug, or?
> 
> UV serial being what actual hardware and system ?

What exact paramteres are you interested in? dmidecode on this machine
says it's an Altix XE310.

thanks,
-- 
js
