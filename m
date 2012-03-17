Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab2CQKx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 06:53:57 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:49583 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab2CQKxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 06:53:55 -0400
Date: Sat, 17 Mar 2012 11:53:24 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Burning multiple DVDs at one time
Message-ID: <20120317115324.10b39bb7@galadriel.home>
In-Reply-To: <20120317095644.145d0588@stein>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
Organization: Intellique
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 17 Mar 2012 09:56:44 +0100 vous écriviez:

> This is likely due to serialization by a global mutex in the sr
> driver. Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive
> performance, remove BKL replacement" from February.
> https://lkml.org/lkml/2012/2/28/230 

When was this regression introduced? I have a dedicated cd burning
machine running 2.6.35.x, and it works great with 4 drives at a time.

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
