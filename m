Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0KCRzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:55:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:46837 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0KCRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:54:58 -0400
Message-ID: <4CD1A0A2.5080507@collabora.co.uk>
Date: Wed, 03 Nov 2010 17:49:22 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: QEMU Developers <qemu-devel@nongnu.org>, virtualization@lists.osdl.org,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com>	<4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com>	<4CC9647A.50108@collabora.co.uk>	<4CC98784.7020907@redhat.com>	<4CC9D472.2080109@collabora.co.uk>	<4CCE9989.2010809@redhat.com> <4CCEBEE2.8010404@codemonkey.ws>	<4CCEE172.2010600@collabora.co.uk> <4CCEE374.4050805@codemonkey.ws>
In-Reply-To: <4CCEE374.4050805@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/10 15:57, Anthony Liguori wrote:

>> It very much is. It supports fully visually integrated rendering (no
>> overlay windows) and even compositing GL window managers work fine,
>> even if running 3D apps under them.
>
> Does the kernel track userspace pid and pass that information to qemu?

Yes. And the qemu code tracks the PIDs and keeps multiple queues (one 
per pid).

-Ian
