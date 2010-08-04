Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab0HDOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:36:49 -0400
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:60046 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757526Ab0HDOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:36:48 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 10:36:48 EDT
Message-ID: <4C5979CC.2050907@kingswood-consulting.co.uk>
Date: Wed, 04 Aug 2010 15:31:40 +0100
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Lightning/1.0b1 Icedove/3.0.4
MIME-Version: 1.0
To: Andre Majorel <aym-xunil@teaser.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: USB card reader trouble
References: <20100804134032.GF10980@aym.net2.nerim.net>
In-Reply-To: <20100804134032.GF10980@aym.net2.nerim.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/10 14:40, Andre Majorel wrote:
> I'm having trouble reading Compact flash and SD cards on the
> same card reader. I'm not absolutely certain but it *seems* that
> once a medium of either type has been inserted, it will ignore
> the other type.
>
> Wherever the state is kept, it's not in the module. modprobe -r
> usb-storage; modprobe usb-storage gives a kernel message about
> "compact flash" even though the only medium in the reader is an
> SD card.

Are you sure that this card reader supports both types of cards 
simultaneously? Some/many/most card readers share signals between the 
connectors to save pins on the IC package.

Frank
