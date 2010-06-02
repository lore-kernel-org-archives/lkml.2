Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab0FBWDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:03:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0FBWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GsUF/vYz0T/V+qVXjSwHPG4Oee82H8wULrKrOhX8G1YNUhQ7G8292GiwCI5h9Tq7CL
         6cDSCuvf4Thj7i10jY8FHWHBUpDv5cXMNBVL1ifdT70UU5USXsvq9c6GNCzOfGMF+R8V
         hhh/E2NbCLLjfruVJ95S6uQF1Mq4HG1ACIYFI=
Subject: Re: strange problem with ricoh-mmc
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b7d3349cdb8e4c118d617ef9df57bf69@localhost>
References: <1275505018.4215.10.camel@maxim-laptop>
	 <04b98a3f757587ee9b72f2e28e257b50@localhost>
	 <1275509965.6277.5.camel@maxim-laptop>
	 <b7d3349cdb8e4c118d617ef9df57bf69@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 01:03:00 +0300
Message-ID: <1275516180.30272.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 16:42 -0400, Philip Langdale wrote: 
> On Wed, 02 Jun 2010 23:19:25 +0300, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > 
> > Thanks.
> > I some future I maybe consider reverse engineering  the MMC controller.
> 
> Someone actually did, if you dig back through the SDHCI mailing list. It's
> apparently almost identical to SDHCI with the Cap flags not set properly.
This is just great.

Maybe its even possible to make SDHCI use it.

> 
> http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html
> 
> Still, even if we got it working properly, it would be rather less elegant
> than what we have today, modulo hardware freaking out as you are
> experiencing...
The curreent version is very elegant....
Like once you resume the system, insert card and is out of ideas of what
to do next....

Thank you very much!


Best regards,
Maxim Levitsky

