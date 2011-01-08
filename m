Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1AHKQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 05:16:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45083 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1AHKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 05:16:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4D283976.4070809@s5r6.in-berlin.de>
Date: Sat, 08 Jan 2011 11:16:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Robin Cook <rcook@wyrms.net>
CC: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
References: <1291592226.7134.1.camel@pheuri.wyrms.net>	 <1291594279.9196.2.camel@maxim-laptop>  <20101206082918.6d1ccc41@stein> <1291673087.4022.2.camel@pheuri.wyrms.net>
In-Reply-To: <1291673087.4022.2.camel@pheuri.wyrms.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Cook wrote on 2010-12-06:
> Output from lspci -nn on the firewire controller.
> 
> 07:00.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]
> 
> The modprobe firewire-ohci quirks=17 worked to get the devices being
> created again.

Thanks Robin,

the regression fix has been released in 2.6.36.3 now.
-- 
Stefan Richter
-=====-==-== ---= -=---
http://arcgraph.de/sr/
