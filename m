Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0KAKnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:43:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0KAKnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:43:02 -0400
Message-ID: <4CCE9989.2010809@redhat.com>
Date: Mon, 01 Nov 2010 06:42:17 -0400
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
        QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com> <4CC9647A.50108@collabora.co.uk> <4CC98784.7020907@redhat.com> <4CC9D472.2080109@collabora.co.uk>
In-Reply-To: <4CC9D472.2080109@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/28/2010 03:52 PM, Ian Molton wrote:
> On 28/10/10 15:24, Avi Kivity wrote:
>>> The caller is intended to block as the host must perform GL rendering
>>> before allowing the guests process to continue.
>>
>> Why is that?  Can't we pipeline the process?
>
> No, not really. the guest may call for the scene to be rendered at any 
> time and we have to wait for that to happen before we can return the 
> data to it.

Waiting for a response is fine, but can't the guest issue a second batch 
while waiting for the first?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

