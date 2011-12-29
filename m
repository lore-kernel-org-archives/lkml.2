Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab1L2GyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:54:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1L2GyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:54:09 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.5.104]
In-Reply-To: <87y5twf16x.fsf@rustcorp.com.au>
References: <8739cbkgv2.fsf@rustcorp.com.au> <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com>
 <CA+55aFzKU0GWqpQo2AzAawoVm=qPaJiwKTcifeYApyZP_Hj3nQ@mail.gmail.com>
 <CAK=WgbacH1tXHJiHNKLNNsFA7-vnFT_J6vYOANh0wzGyUj8Zpg@mail.gmail.com> <87y5twf16x.fsf@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 29 Dec 2011 08:53:48 +0200
Message-ID: <CAK=WgbZzhFS3tTpywN2HUdjmpTuWSqg9BCC9=QaO10=d_ACRiA@mail.gmail.com>
Subject: Re: [RESENDx2] [PULL] virtio: fix barriers for virtio-mmio
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 6:31 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> OK, I've applied this patch; you might want to carry it in your tree
> too.  You'll need to fix up your call to vring_new_virtqueue()....

Will do. Thanks !
