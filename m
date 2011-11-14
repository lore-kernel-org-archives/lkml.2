Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1KNUaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:30:25 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38800 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170Ab1KNUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:30:24 -0500
X-Sasl-enc: pfQj8VIoQlyEbSIy3hgNseHpWn7xMlWfw5f+NmiI8Vvu 1321302623
Date: Mon, 14 Nov 2011 18:30:21 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Natanji <natanji@gmail.com>
Cc: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
Message-ID: <20111114203021.GC31918@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC16F8E.7060601@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Natanji wrote:
> With 3.0 it was still fine, that much is for sure. The problem came 
> with the upgrade to 3.1. I've never even compiled my own kernel so I 
> cannot bisect. Sorry...

Well, please keep me in the CC.  I'm the thinkpad-acpi maintainer.

> >> This can be observed by using the acpi_listen command. For instance, no
> >> ACPI events happen when swiveling the display, and the sleep button returns
> >> 	button/sleep SBTN 00000080 00000000
> >> instead of the previous
> >> 	ibm/hotkey HKEY 00000080 00001004

That usually happens when you don't have thinkpad-acpi loaded at all.

Does lsmod report that thinkpad-acpi is loaded?  Are there any messages from
thinkpad-acpi in the kernel log?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
