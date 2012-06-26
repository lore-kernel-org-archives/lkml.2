Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2FZXUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:20:38 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:4324 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2FZXUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:20:37 -0400
Message-ID: <4FEA4343.7080008@spin.net.au>
Date: Wed, 27 Jun 2012 09:18:27 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120604 Firefox/13.0 SeaMonkey/2.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: UEFI and custom kernel
References: <4FEA4102.2080900@spin.net.au> <20120627001925.56e350f8@pyramind.ukuu.org.uk>
In-Reply-To: <20120627001925.56e350f8@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.181, required 4, AWL 0.32, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> For x86 the UEFI "secure" boot requirement is that the user can 
> disable secure boot. For ARM it is that the user *cannot* disable 
> secure boot. So in the PC space at least it's "business as usual" 
> providing you jump that hoop, and hopefully with the tools sorted 
> it'll be viable to sign your own kernels and use your own keys. Alan 

Thanks Alan. I never realized that for x86 based hardware, nothing would 
change once disabled. In fact, I was not even aware that it could be 
disabled to begin with. Thank you.


Regards

-- 
		Chris Jones @ kernel.devproject@gmail.com
                           and oracle.kerneldev@gmail.com

OpenSUSE Linux x86_64 (PC)|Android (Smartphone)|Windows 7 (Laptop)|Windows XP (Gaming)
Linux kernel developer|Solaris kernel developer|Lead Developer of SDL|Lead Developer of Nest Linux
Gamer and Emulator nut|Web Services|Digital Imaging Services
Controllers: Rapier V2 Gaming mouse|Logitech Precision|PS3 controller|XB360 controller|Logitech Attack 3 j/stick
Emulators: Fusion|Gens|ZSNES|Project64|PCSX-R|Stella|WinVICE|WinUAE|DOSBox

