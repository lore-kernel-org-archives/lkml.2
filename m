Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0EJMLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:11:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37015 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab0EJMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:11:06 -0400
X-Sasl-enc: 41yRjVpNbRQG5tQPZeFNuGhGROob3GwVA+tEUcoEGYdN 1273493438
Date: Mon, 10 May 2010 09:10:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: borislav@users.sf.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: add support for thinkpad x100e
Message-ID: <20100510121034.GA7164@khazad-dum.debian.net>
References: <4BE70795.6060403@udo.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE70795.6060403@udo.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 May 2010, Andrej Gelenberg wrote:
> Embedded controller path is "\\_SB.PCI0.LPC0.EC" on Lenovo Thinkpad X100e.

Yeah, and I have a proper fix queued already, that locates the EC by
HID, so NACK.

However, even that is not enough.  The vid_handle needs to be fixed as
well, and there are a few bugs in that area that make it somewhat
not-a-good-idea to just fix the EC detection.

This is why I didn't push the simple fix yet.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
