Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0JBKO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:14:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46410 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0JBKOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=M7RbVyu/XFr70HOple/n48r01v5dFR5hIZ0FlbjGFaX75rSz4+UJDBvzvYKPi4oTZt
         Pt9AbQLIT2QgD/ilbg9znCVRiBtbUYze/SDc7q0+4vDwkwKarFhbINP8kvudghRE1C5Y
         T0mzop8DSwL9QH4LaFTqw8Rt6YJc2DV1GpMQk=
MIME-Version: 1.0
In-Reply-To: <AANLkTinq16F1oh=gj_hs=w8fMWo7VuArC3m4-SUWp+Nr@mail.gmail.com>
References: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
 <AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
 <AANLkTimnSzAWJW417_XR60umT_k47AFWDdDPPD3yhbLG@mail.gmail.com> <AANLkTinq16F1oh=gj_hs=w8fMWo7VuArC3m4-SUWp+Nr@mail.gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 15:44:03 +0530
Message-ID: <AANLkTi=cfyBTUHfxXBDf_mAdsfz=Fw01rxxFeeR7WANn@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ming.
I have certain doubts related to device_unregister()

In some of USB related code..
kfree() is called after device_unregister() ...  device_unregister()
also internally calls put_device()... is that correct behavior or I'm
missing something here..
ex.
file : drivers/usb/gadget/fsl_udc_core.c
function : static int __init fsl_udc_probe(struct platform_device *pdev)


- Rahul Ruikar





On 2 October 2010 15:28, Ming Lei <tom.leiming@gmail.com> wrote:
> 2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
>> revised patch attached.
>
> Acked-by: Ming Lei <tom.leiming@gmail.com>
>
> --
> Lei Ming
>
