Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0FOKEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:04:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33940 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752013Ab0FOKD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:03:58 -0400
Date: Tue, 15 Jun 2010 11:07:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Alan <alan@clueserver.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
Message-ID: <20100615110748.4303a106@lxorguk.ukuu.org.uk>
In-Reply-To: <20100615065714.GA9034@bitwizard.nl>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
	<4C10A81F.50801@garzik.org>
	<54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
	<20100615065714.GA9034@bitwizard.nl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A reboot brings the disks back to life. So in theory, Linux should be
> able to restore life into these drives by doing the right magic with
> the hardware bits... 

We don't have power control of the drives. If the firmware crashes or a
drive flakes out due to power problems or something similar occurs its
game over until you hit the switch.

> ata5: hard resetting link
> ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 370)

We tried the biggest hammer we had

Alan
