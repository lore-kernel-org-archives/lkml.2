Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2DYIon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:44:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56642 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab2DYIol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:44:41 -0400
X-Sasl-enc: KKSV1qJc/EjKjDknw/cgK6QepR0DrhTjtJHO7lDsnmFp 1335343479
Message-ID: <4F97BA60.4080505@ladisch.de>
Date: Wed, 25 Apr 2012 10:48:32 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: andymatei@gmail.com
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no> <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no> <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
In-Reply-To: <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andymatei@gmail.com wrote:
> I have bought the Asus E45M1-M PRO to use in my home storage. [...]
> I get "Disabling IRQ 16" and "Disabling IRQ 19". [...]
> Is there a patch or something that resolves this issue yet?

As far as I remember, this is a hardware bug in the ASMedia PCIe/PCI
bridge.  This can neither easily nor completely be worked around in
software.


Regards,
Clemens
