Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422951Ab2JaOfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:35:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39169 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2JaOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <20121031132650.GP10998@arwen.pp.htv.fi>
References: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
	<1351670761-26749-2-git-send-email-xtfeng@gmail.com>
	<20121031132650.GP10998@arwen.pp.htv.fi>
Date: Wed, 31 Oct 2012 22:35:37 +0800
X-Google-Sender-Auth: smXrfQGbwEb8y6Re39H72NvegNg
Message-ID: <CADRPPNSQzCrHRQMoFf280pqS7AUOAzOq-swT3Hwagphiire5-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] usb: gadget: fsl_qe_udc: do not use tasklet_disable
 before tasklet_kill
From: Li Yang <leoli@freescale.com>
To: balbi@ti.com
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 9:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 31, 2012 at 04:06:00PM +0800, Xiaotian Feng wrote:
>> If tasklet_disable() is called before related tasklet handled,
>> tasklet_kill will never be finished. tasklet_kill is enough.
>
> how did you test this ? Why changing FSL driver instead of switching
> over to chipidea which is supposed to be shared by every licensee of the
> chipidea core ?

The QE UDC is an private controller that is not compatible with the
Chipidea core.

- Leo
