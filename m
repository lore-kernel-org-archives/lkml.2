Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1EBPvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:51:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61996 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1EBPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Ld0ntmS7RY0Fq2oCbl3oL9ybg8QfxxD6Xdc2EvJ/Qjb7KQfdrZwRsckmuVUWJaNXRP
         4NdTcy1AGaUZfoSxoMYLxiCJcvY7RmapsRTQsTHIJoTwBYbCKEWD716V7QpnR+mRp0aG
         k0nUH8iG2E/ZOrYYZnFlTXzdHaOg/IolVQ0Dg=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <20110502154322.GB8098@suse.de>
References: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
	<1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
	<20110502154322.GB8098@suse.de>
Date: Mon, 2 May 2011 23:51:45 +0800
X-Google-Sender-Auth: bFV1UlmrQQ_5YG7vwTDu_OBzIK0
Message-ID: <BANLkTi=fYSYWx4XX64meSHHKDENVCviAAQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KernelDoc:Add the device driver-model structures to kerneldoc
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/11, Greg KH <gregkh@suse.de> wrote:

> Again, the driver core's private data, not the driver's private data,
> very big difference.  No one other than the driver core can touch this.
>
> Same goes for the other comments you added...
>
> I think this needs a whole lot more description than what you have
> provided in order for it to be acceptable.
>
> Care to work on it?
>
> thanks,
>
> greg k-h
Greg:
Thanks for your comments and I will do my best and resend the patch.

Thanks
Wanlong Gao
