Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0FMCOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 22:14:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34134 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0FMCOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 22:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m1ZxB/zvSHuq012y+DFgqmrOgrTm2DuATFDKMzQrFwMFIPp1eeuSKIoYgiybs53VwW
         xRhVzPer7JBKdo3+Dtv1CerPyYvoN9gCtKhcq/ZarKrzeuwdti2Fc29doN0ZAX2MF2nO
         pLJLnzAJn0TBFCkcyAhBivFNJU+MHqIF01FjM=
MIME-Version: 1.0
In-Reply-To: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
Date: Sun, 13 Jun 2010 10:14:41 +0800
Message-ID: <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
From: Mark Rankilor <reodge@gmail.com>
To: =?ISO-8859-1?Q?Henri_H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/12 Henri Häkkinen <henuxd@gmail.com>:
> -                       printk
> -                           (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +                       printk(KERN_INFO "comedi: failed to increment module "
> +                              "count, skipping\n");

Hi Henri,

Regarding your breaking up of printk statements, although some of
those lines do go over 80 characters, it is preferable to keep the
strings together since then those are searchable within the code.

I figure it is quite acceptable to break the string after "comedi: ",
so maybe that will fix the line length issue, otherwise it is
preferable to keep the checkpatch warning in this case.

Mark
