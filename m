Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1AYLKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:10:07 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:27714 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1AYLKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:10:04 -0500
Message-ID: <4D3EAF22.5090102@snapgear.com>
Date: Tue, 25 Jan 2011 21:08:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <greg@kroah.com>,
        Greg Ungerer <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 68328serial: remove unsed m68k_serial->tqueue_hangup
References: <20110124165341.GE27510@htj.dyndns.org> <20110124175606.51bb5a9f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110124175606.51bb5a9f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

On 25/01/11 03:56, Alan Cox wrote:
> On Mon, 24 Jan 2011 17:53:41 +0100
> Tejun Heo<tj@kernel.org>  wrote:
>
>> m68k_serial->tqueue_hangup is unused.  Remove it.
>
> Curious - is anyone actually using this driver ?

It is the serial driver used with the Motorola/Freescale 68x328
family. I don't know that many people would be using the most
recent kernels on them. I compile it once in a while so that it
at least compiles, but I don't have any hardware myself based on it.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
