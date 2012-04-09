Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2DIM0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:26:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53626 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2DIM0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:26:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 9 Apr 2012 14:26:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kristian Hoegsberg <krh@bitplanet.net>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: use module_pci_driver
Message-ID: <20120409142633.718209a8@stein>
In-Reply-To: <1333418821.18133.8.camel@phoenix>
References: <1333418821.18133.8.camel@phoenix>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 03 Axel Lin wrote:
> This patch converts the drivers in drivers/firewire/* to use module_pci_driver()
> macro which makes the code smaller and a bit simpler.

Committed to linux1394.git.  Thanks,
-- 
Stefan Richter
-=====-===-- -=-- -=--=
http://arcgraph.de/sr/
