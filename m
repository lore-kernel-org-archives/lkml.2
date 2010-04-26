Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0DZWBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:01:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46336 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396Ab0DZWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:01:37 -0400
Date: Mon, 26 Apr 2010 23:06:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npelly@google.com" <npelly@google.com>,
       "pavan_savoy@yahoo.co.in" <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
Message-ID: <20100426230642.3c13796f@lxorguk.ukuu.org.uk>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E1EBF9F@dbde02.ent.ti.com>
References: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
	<1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
	<20100426225957.532559a2@lxorguk.ukuu.org.uk>
	<19F8576C6E063C45BE387C64729E7394044E1EBF9F@dbde02.ent.ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Doesn't directly apply as NR_LDISCS is now 21 but this should definitely
> > go in.
> 
> 
> It has I believe, Greg has modified it to 30, and pulled in his tree.

Cool (I'm looking at -next)

Alan

