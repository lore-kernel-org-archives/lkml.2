Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab1LORrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:47:55 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44591 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758974Ab1LORry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:47:54 -0500
X-Sasl-enc: /ysZpG26Zb46iR01DWgIzBTjrOycjnNet4X5ykiaPK8b 1323971273
Message-ID: <4EEA331F.1060201@ladisch.de>
Date: Thu, 15 Dec 2011 18:49:19 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julian Sikorski <belegdol@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: bug report: irq 19: nobody cared (try booting with the "irqpoll"
 option)
References: <4EEA0485.4050105@gmail.com> <4EEA0521.2030502@gmail.com> <4EEA18A8.5030603@ladisch.de> <4EEA1A81.6030807@gmail.com>
In-Reply-To: <4EEA1A81.6030807@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Sikorski wrote:
> W dniu 15.12.2011 16:56, Clemens Ladisch pisze:
>> Julian, try disabling DMAR (probably called IOMMU or something related
>> to virtualization) in the BIOS.
>
> There is no such option or anything even remotely related in the BIOS

Then add the kernel parameter intel_iommu=off to the boot loader.


Regards,
Clemens
