Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1JMQLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:11:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63587 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab1JMQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:10:52 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] pata_it8213: fix register naming used in it8213_set_piomode()
Date: Thu, 13 Oct 2011 18:10:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201110131744.23090.bzolnier@gmail.com> <20111013165405.3d4d93b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20111013165405.3d4d93b8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131810.02228.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> On Thu, 13 Oct 2011 17:44:22 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH v2] pata_it8213: fix register naming used in it8213_set_piomode()
> > 
> > Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
> > and 'master_data' respectively to match register naming used in
> > it8213_set_dmamode() and in ata_piix.c.
> 
> I do question this renaming. Surely we should reflect the names on the
> data sheets if anything ?

Please lets have some consistency in the driver first (same names used
in ->set_piomode and ->set_dmamode)..  we can always do global rename
later if needed.
 
