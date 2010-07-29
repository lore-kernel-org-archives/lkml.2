Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0G2QON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:14:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35190 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757875Ab0G2QOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:14:12 -0400
X-Sasl-enc: ekB8xV/bj/J3QWwzk/rR3UIeLhvA+VjrI5g72rBX/KC5 1280420051
Date: Thu, 29 Jul 2010 13:14:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fernand LONE SANG <fernand.lone-sang@laas.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i2cdetect outputs on Intel x58 chipsets wanted
Message-ID: <20100729161408.GA26738@khazad-dum.debian.net>
References: <20100729081626.GE4966@laas.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729081626.GE4966@laas.fr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Fernand LONE SANG wrote:
> help, i'm looking for some kind people, with an Intel x58 chipset, who
> can send me by email their outputs from the i2cdectect tool so i can
> identify the motherboard version that have this component.

SuperMicro C7X58 v1.0 (there is a V1.1 board now), latest BIOS (1.1a).
dmidecode information is useless on this board.

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- 08 -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- 18 -- 1a -- 1c -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- 2e -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- 3e -- 
40: -- -- -- -- 44 -- -- -- -- -- -- -- -- -- -- -- 
50: 50 -- 52 -- 54 -- -- -- -- -- -- -- -- -- -- -- 
60: -- 61 -- -- -- -- -- -- -- 69 -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --                         

This is a X58 IOH rev 12 (there is a newer stepping of the X58).

Also, it could well be that the BIOS can configure the X58 IOH to hide
devices.  May also depend on what the firmware is doing to the X58 embedded
controller.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
