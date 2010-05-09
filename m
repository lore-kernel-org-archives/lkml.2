Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0EIOzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:55:01 -0400
Received: from topdeck.tinsleyviaduct.com ([62.49.246.82]:47493 "EHLO
	topdeck.tinsleyviaduct.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab0EIOy7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:54:59 -0400
X-Greylist: delayed 2459 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 May 2010 10:54:59 EDT
Message-ID: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
Date: Sun, 09 May 2010 15:13:58 +0100
From: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
To: linux-kernel@vger.kernel.org
Subject: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently had cause to start using the eSATA port on my  
motherboard, an Asus M3A79-T Deluxe, but have found that it is not in  
AHCI mode and therefore not hotplug capable. There are no settings for  
the Marvell 88SE6121 controller available, other than simply whether  
it is enabled or not.

I gather from reading elsewhere that the kernel can put this  
controller into AHCI - I found a patch but found it was already  
present in the kernel in Debian lenny's backports. It is their version  
2.6.32-bpo.3 - not entirely sure which exact source version this is  
built from. However, this patch does not work on this motherboard -  
either that or I have to make it active somehow, and the method of  
doing so is not obvious.

Of course, I could be missing something simple - if so, please accept  
my apologies and point me in the right direction.

However, if further information or testing is required, I am more than  
happy to assist in any way I can.

I am not on the linux-kernel mailing list at present, so please CC any  
replies to the address I sent this from.

Thanks in advance for any assistance.

-- 
Phil Reynolds
email: phil-linux@tinsleyviaduct.com
Not subscribed to lkml - please CC replies to me

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
