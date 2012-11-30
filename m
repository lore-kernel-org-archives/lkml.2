Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2K3B6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:58:38 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45308 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782Ab2K3B6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:58:36 -0500
X-Sasl-enc: pO2Sf7WyyIVzWmhoq/Usws8r/RUvmyuolHPrfQwjWbij 1354240715
Message-ID: <50B812CD.5000802@signal11.us>
Date: Thu, 29 Nov 2012 20:58:37 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 6lowpan: consider checksum bytes in fragmentation threshold
References: <504EA95C.9010003@signal11.us> <1354240544-22214-1-git-send-email-alan@signal11.us>
In-Reply-To: <1354240544-22214-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 08:55 PM, Alan Ott wrote:
> Change the threshold for framentation of a lowpan packet from
> using the MTU size to now use the MTU size minus the checksum length,
> which is added by the hardware. For IEEE 802.15.4, this effectively
> changes it from 127 bytes to 125 bytes.
>

Sorry, this was put in the wrong thread. One day I'll get one of these
first-try. :(
