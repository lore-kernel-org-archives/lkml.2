Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2HNPaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:30:14 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60924 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab2HNPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:30:12 -0400
X-Sasl-enc: ViWWs7XGImHiaI6wecTih93G7bBLzhRNyBodeQizryRH 1344958211
Date: Tue, 14 Aug 2012 12:30:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: Seeing the microcode revision in /proc/cpuinfo
Message-ID: <20120814153008.GA21885@khazad-dum.debian.net>
References: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Ulrich Windl wrote:
> After several reboots due to memory errors after excellent power-saving of
> Linux on a HP DL380G7 with Intel Xeon 5650 processors (all in on memory
> bank), I found out the errate "BD104" and "BD123". The former should be
> fixed in a microcode revision "15H".

Hmm, BD104 is indeed nasty.  And that microcode update is not available
to the general public (i.e. through downloadcenter.intel.com).

> Now I wonder what microcode revision my CPUs currently have. /proc/cpuinfo
> doesn't show that, and the microcode update is a bit cryptic:
> 
> kernel: [   44.422912] microcode: CPU23 sig=0x206c2, pf=0x1, revision=0x14

You have revision 0x14.

Presumably, you will get revision 0x15 if you update the HP firmware in
that box.  The update you need was published by HP nearly an year ago.

> Does that mean the revision is 0x14 BEFORE or AFTER the microcode update?

Before.  The message you get when the CPU is updated is different.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
