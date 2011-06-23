Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab1FWC0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:26:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab1FWC0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B5l9UP8uLCnwsMfB3V+tIKsoKlwpxA8uquIiwYmkeZ9Mp57rT980Z3nyPpjXMbcx5S
         nGIwQ8po8mhdSIWP01PRK6xcQ+ZOB0RRUib48dytbl7i0yPkV42aY3Zv8Vo+JfgHW69U
         nr/TkS78p011+gHZCB9mFw6SF/zLVyK85j9to=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=tut=Y4fc4tkT8wt_q1azJOYaDoQ@mail.gmail.com>
References: <20110621102605.1382.90232.sendpatchset@t400s>
	<20110621102623.1382.71841.sendpatchset@t400s>
	<BANLkTi=tut=Y4fc4tkT8wt_q1azJOYaDoQ@mail.gmail.com>
Date: Thu, 23 Jun 2011 11:26:34 +0900
Message-ID: <BANLkTimSj9iMeYJ8X7SCocVDfbGUPGotRw@mail.gmail.com>
Subject: Re: [PATCH 02/02] virtio: Add virtio platform driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        horms@verge.net.au, mst@redhat.com, iws@ovro.caltech.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, Jun 22, 2011 at 3:27 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Tue, Jun 21, 2011 at 06:26, Magnus Damm wrote:
>> +config VIRTIO_PLATFORM
>> +       tristate "Platform driver for virtio devices (EXPERIMENTAL)"
>> +       select VIRTIO
>> +       select VIRTIO_RING
>> +       select VIRTIO_LGUEST
>> +       ---help---
>> +        This drivers provides support for virtio based paravirtual device
>> +        drivers over a platform bus.
>> +
>> +        If unsure, say N.
>
> be nice to add a note as to the name of the module if the user selects "M"

Yes, good idea!

>> --- /dev/null
>> +++ work/drivers/virtio/virtio_platform.c       2011-03-03 16:07:31.000000000 +0900
>> --- /dev/null
>> +++ work/include/linux/virtio_platform.h        2011-03-03 15:56:54.000000000 +0900
>
> both files lack a comment block at the top
> /*
>  * one line desc of file
>  *
>  * copyright
>  *
>  * license blurb
>  */

Sure! I will include these changes in the next version!

Thank you!

/ magnus
