Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2C2MvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:51:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64312 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab2C2MvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F744E23.3040207@mvista.com>
References: <4F739CBB.8060602@gmail.com>
	<4F744E23.3040207@mvista.com>
Date: Thu, 29 Mar 2012 21:51:05 +0900
Message-ID: <CAM1upfMY=fh_XgYuY69SOZEz7y0G3hdqvZxoBWTDVGH5j7ixyQ@mail.gmail.com>
Subject: Re: [PATCH] USB: yurex: remove allocation of coherent buffer for
 setup-packet buffer
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012年3月29日20:57 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 29-03-2012 3:20, Tomoki Sekiyama wrote:
>
>> Removes allocation of coherent buffer for the control-request setup-packet
>> buffer from the yurex driver. Using coherent buffers for setup-packet is
>> obsoleted and does not work with some USB host implementations.
>
>> This patch also fixes missing URB_NO_TRANSFER_DMA_MAP flag in urb.
>
>   Looks like the patch should be split into two then as it does two different
> things.
>
> WBR, Sergei

OK, I will split this patch into two pieces and re-send them.

Thank you,

Tomoki Sekiyama
