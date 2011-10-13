Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1JMQKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:10:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49914 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1JMQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:10:46 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] pata_oldpiix: enable parallel scan
Date: Thu, 13 Oct 2011 18:06:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201110131603.34443.bzolnier@gmail.com> <20111013164753.69a5e92c@lxorguk.ukuu.org.uk>
In-Reply-To: <20111013164753.69a5e92c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131806.27248.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> On Thu, 13 Oct 2011 16:03:34 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_oldpiix: enable parallel scan
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Have you tested this. When I talked with Intel people about parallel
> scanning nobody in Intel I could find could answer whether it was safe on
> the ancient PIIX versions.

No, it wasn't tested on the real hardware.

I think it should be in libata-dev or -mm/-next for rather long time..
