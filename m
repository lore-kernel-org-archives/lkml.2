Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1JULSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:18:24 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:53077 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab1JULSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:18:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Oct 2011 07:18:22 EDT
Message-ID: <4EA1536E.6090001@profihost.ag>
Date: Fri, 21 Oct 2011 13:11:42 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stable Tree <stable@kernel.org>, Greg KH <gregkh@suse.de>
Subject: Kernel hard LOCKUP with v3.0.7
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

today i've seen the following crash using v3.0.7 (renamed to 2.6.40.7).

http://pastebin.com/raw.php?i=sRq7T4Y0

I haven't seen this with 3.0.6 but i also changed some kernel config 
options (activated ipv6, changed from SLAB to SLUB).

Greets Stefan
