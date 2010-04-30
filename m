Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0D3QvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:51:23 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:49527 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab0D3QvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=d+YT/eg5YsanJHiAoaTudGmvIcX6O1BH0yxwDrrAq4Y6y3cAI5Jdv8IbusQ0ToJog2
         g6LbL+bwPA5NdBGpTVXghGg++9AoE+Jge2S6cmcLAbI11Td6Ibs6sNTkYl5KWMrX1w7K
         q6IvWr76Kit6vCbBhn9BCqp/PeEUQZdz93Jcs=
Date: Fri, 30 Apr 2010 09:40:36 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg KH <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] staging: crystalhd: remove unused bc_dts_types.h
Message-Id: <20100430094036.2dc10a8f.yuasa@linux-mips.org>
In-Reply-To: <20100429191043.GF21799@kroah.com>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
	<20100429191043.GF21799@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 12:10:43 -0700
Greg KH <greg@kroah.com> wrote:

> On Sun, Apr 25, 2010 at 10:18:51PM +0900, Yoichi Yuasa wrote:
> > Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> > ---
> >  drivers/staging/crystalhd/bc_dts_defs.h  |    2 -
> >  drivers/staging/crystalhd/bc_dts_types.h |  121 ------------------------------
> 
> Wait, all crystalhd patches should go through Ralf's tree, can you send
> these to him instead?

These patches are not related to MIPS.
I just sent to you.

Thanks,

Yoichi
