Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1FLXhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 19:37:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42478 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FLXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 19:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s9guYP9/AGM4h7F+QG4Bca9/F5F9xCi+SIzPw7w8fEibXLK4G4Wb3ernhqqwgIA/6E
         xhAgQ/dGBx/hFHncA+bElBBM3ZniCouMRRjUOqwnYVimbcjo9juu10HNo7kLpQSdNU+K
         qgA2dR8w/uBLt/ZUoCf7p7N1JAW4ogtwPi4tY=
Subject: Re: [PATCH] efifb: Fix call to wrong unregister function
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
In-Reply-To: <BANLkTimXALxHwNMSODXujT4pT-C+m3rcaQ@mail.gmail.com>
References: <1307875953.1859.6.camel@Tux>
	 <BANLkTimXALxHwNMSODXujT4pT-C+m3rcaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 07:36:47 +0800
Message-ID: <1307921807.1934.0.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2011-06-12 at 19:48 +0200, Maarten Lankhorst wrote:
> Hey,
> 
> 2011/6/12 wanlong.gao <wanlong.gao@gmail.com>:
> > <snip>
> >
> > Hi Maarten:
> > It registered efifb_device but try to unregistered efifb_driver,
> > so I think you should fix it like this?
> Ah yes, that seems to be the correct one, platform_driver_register was
> removed. Not 100% sure if acked by or signed-off-by is appropriate
> here.
I think signed-off-by is OK.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> ~Maarten


