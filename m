Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0FJJGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:06:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0FJJGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kdBz251rrNPFGtQTcgU1Qo+Lbv/wYs20pHI2oPGjPHfpgC/HN4bjhnpvlZeM4G5imY
         z/tlhUk8knzOAp9GNJsx84Qw48QNXU+J1gy4ChOAp1xOnseOTcfinAYCDQ2i/rpmObsu
         gmujdWuu6JKAoSUX/xkf4b6T4pbjp73d/KH8w=
MIME-Version: 1.0
In-Reply-To: <87vdacl15j.fsf@openvz.org>
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
	<87vdacl15j.fsf@openvz.org>
Date: Thu, 10 Jun 2010 11:06:17 +0200
Message-ID: <AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't see anything which would generate this warning in 2.6.33.4's
> > fs/fs-writeback.c:597.  RH must have mucked with it.
> Already fixed in mainstream by
> commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Tue May 18 14:29:29 2010 +0200

Do you send it to stable ? I am hitting the same bug and count is high
on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)

Bastien
