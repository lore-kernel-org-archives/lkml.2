Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2DJMyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:54:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54650 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2DJMyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:54:00 -0400
Message-ID: <1334062437.2141.11.camel@hornet>
Subject: Re: [PATCH 2/2] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 10 Apr 2012 13:53:57 +0100
In-Reply-To: <CA+1xoqfov64Wz9e_G8ZTcXnAatw_VqYxecU5FX3Zrmw_XTL-Cw@mail.gmail.com>
References: <1323712401.2391.93.camel@hornet.cambridge.arm.com>
	 <1323712627-17353-1-git-send-email-pawel.moll@arm.com>
	 <1323712627-17353-2-git-send-email-pawel.moll@arm.com>
	 <CA+1xoqfov64Wz9e_G8ZTcXnAatw_VqYxecU5FX3Zrmw_XTL-Cw@mail.gmail.com>
X-Mailer: Evolution 3.2.2-
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Apr 2012 12:55:04.0177 (UTC) FILETIME=[25F0C610:01CD1719]
X-MC-Unique: 112041013535702601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 12, 2011 at 6:57 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> > This patch adds an option to instantiate guest virtio-mmio devices
> > basing on a kernel command line (or module) parameter, for example:
> >
> >        virtio_mmio.devices=0x100@0x100b0000:48
> >
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>

On Mon, 2012-04-09 at 17:32 +0100, Sasha Levin wrote:
> Ping? Was this patch forgotten?

Damn, it has been forgetten indeed. It took a while to get the required
"<level>-param" patch got merged and then it slipped through cracks...

I'll re-test it against v3.4-rc and make sure it gets queued for 3.5
(3.4 is unlikely, especially now when Rusty is honeymooning ;-)

Thanks for the reminder and sorry about the delay!

Paweł


