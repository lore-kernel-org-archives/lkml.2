Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1ENTm2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:42:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51127 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ENTm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FgAJtmlVNlluUVypf64OZn0MlPMksdywGMpmNRgONqRZzPH95J8gHuYaO3M31mGRLD
         X4/vJb4OkArHlzCuzy7wzEWDVzDfudy/Ac/W0olMQqc96chSlq+GcLaVJLudBjVEmHoQ
         BvRZDuat4nKil83fOAZJ0Gn/zHx6jG3eDra9o=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105040522250.4503@localhost6.localdomain6>
References: <alpine.DEB.2.00.1105040522250.4503@localhost6.localdomain6>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sat, 14 May 2011 13:41:55 -0600
Message-ID: <BANLkTikzWDa8SbULd45_ReDzweR6pnZsQA@mail.gmail.com>
Subject: Re: [PATCH] PC8736X: Correct dev_dbg() message showing major number.
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 3:26 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
> Currently, the debugging info is incorrect, as a successful call to
> either register_chrdev_region() or alloc_chrdev_region() returns
> simply zero, which appears to be what the following code would print.
> Skip the checking, just print the value of "major", which should be
> correct.
>
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> ---


NAK.  'dynamic' is not always correct

> +       dev_dbg(&pdev->dev, "got dynamic major %d\n", major);

Ive got patches to replace register|alloc _chrdev_region
which may require merge conflict resolution.
Id prefer to hold off til theyre reviewed, accepted.

Actually, shouldnt conflict - rc<0 code is in between.
If you want to rework it, I'll ack it.

thanks.
