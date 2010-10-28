Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0J1T6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:58:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:51900 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0J1T6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:58:02 -0400
Message-ID: <4CC9D472.2080109@collabora.co.uk>
Date: Thu, 28 Oct 2010 20:52:18 +0100
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
        QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com> <4CC9647A.50108@collabora.co.uk> <4CC98784.7020907@redhat.com>
In-Reply-To: <4CC98784.7020907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/10 15:24, Avi Kivity wrote:
>> The caller is intended to block as the host must perform GL rendering
>> before allowing the guests process to continue.
>
> Why is that?  Can't we pipeline the process?

No, not really. the guest may call for the scene to be rendered at any 
time and we have to wait for that to happen before we can return the 
data to it.

-Ian
