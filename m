Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0KAPyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:54:40 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:51826 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab0KAPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:54:39 -0400
Message-ID: <4CCEE172.2010600@collabora.co.uk>
Date: Mon, 01 Nov 2010 15:49:06 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com>	<4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com>	<4CC9647A.50108@collabora.co.uk> <4CC98784.7020907@redhat.com>	<4CC9D472.2080109@collabora.co.uk> <4CCE9989.2010809@redhat.com> <4CCEBEE2.8010404@codemonkey.ws>
In-Reply-To: <4CCEBEE2.8010404@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/10 13:21, Anthony Liguori wrote:
> On 11/01/2010 05:42 AM, Avi Kivity wrote:
>> On 10/28/2010 03:52 PM, Ian Molton wrote:
>>> On 28/10/10 15:24, Avi Kivity wrote:

>> Waiting for a response is fine, but can't the guest issue a second
>> batch while waiting for the first?

> The other scenario would be multiple applications trying to use GL but
> AFAICT, this is not supported in the current model.

It very much is. It supports fully visually integrated rendering (no 
overlay windows) and even compositing GL window managers work fine, even 
if running 3D apps under them.

-Ian
