Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1FUS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:27:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab1FUS1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oIpgDZun4ZGLf9Xl4xcdd3ZJYGpBBFN9VFBmaRrjP9j17tsgUG6rgBkKcx9VVLbyRh
         liS/+vCZkUoAfbwcOUpxdwlgHCY9nOZEifyvOPd0AO58EvVs+UH9sb+KAK0Eteetr6l1
         EQb5gLheC34rRmObrXct3f+M6FFQcO5CdyWI8=
MIME-Version: 1.0
In-Reply-To: <20110621102623.1382.71841.sendpatchset@t400s>
References: <20110621102605.1382.90232.sendpatchset@t400s> <20110621102623.1382.71841.sendpatchset@t400s>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 21 Jun 2011 14:27:33 -0400
X-Google-Sender-Auth: 6xpgXv5bz_BtYhv_ZrjkIoitO_U
Message-ID: <BANLkTi=tut=Y4fc4tkT8wt_q1azJOYaDoQ@mail.gmail.com>
Subject: Re: [PATCH 02/02] virtio: Add virtio platform driver
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        horms@verge.net.au, mst@redhat.com, iws@ovro.caltech.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 06:26, Magnus Damm wrote:
> +config VIRTIO_PLATFORM
> +       tristate "Platform driver for virtio devices (EXPERIMENTAL)"
> +       select VIRTIO
> +       select VIRTIO_RING
> +       select VIRTIO_LGUEST
> +       ---help---
> +        This drivers provides support for virtio based paravirtual device
> +        drivers over a platform bus.
> +
> +        If unsure, say N.

be nice to add a note as to the name of the module if the user selects "M"

> --- /dev/null
> +++ work/drivers/virtio/virtio_platform.c       2011-03-03 16:07:31.000000000 +0900
> --- /dev/null
> +++ work/include/linux/virtio_platform.h        2011-03-03 15:56:54.000000000 +0900

both files lack a comment block at the top
/*
 * one line desc of file
 *
 * copyright
 *
 * license blurb
 */
-mike
