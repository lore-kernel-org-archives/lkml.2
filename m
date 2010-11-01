Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0KAP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:57:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40550 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0KAP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:57:47 -0400
Message-ID: <4CCEE374.4050805@codemonkey.ws>
Date: Mon, 01 Nov 2010 10:57:40 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: Avi Kivity <avi@redhat.com>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com>	<4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com>	<4CC9647A.50108@collabora.co.uk> <4CC98784.7020907@redhat.com>	<4CC9D472.2080109@collabora.co.uk> <4CCE9989.2010809@redhat.com> <4CCEBEE2.8010404@codemonkey.ws> <4CCEE172.2010600@collabora.co.uk>
In-Reply-To: <4CCEE172.2010600@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 10:49 AM, Ian Molton wrote:
> On 01/11/10 13:21, Anthony Liguori wrote:
>> On 11/01/2010 05:42 AM, Avi Kivity wrote:
>>> On 10/28/2010 03:52 PM, Ian Molton wrote:
>>>> On 28/10/10 15:24, Avi Kivity wrote:
>
>>> Waiting for a response is fine, but can't the guest issue a second
>>> batch while waiting for the first?
>
>> The other scenario would be multiple applications trying to use GL but
>> AFAICT, this is not supported in the current model.
>
> It very much is. It supports fully visually integrated rendering (no 
> overlay windows) and even compositing GL window managers work fine, 
> even if running 3D apps under them.

Does the kernel track userspace pid and pass that information to qemu?

Regards,

Anthony Liguori

> -Ian

