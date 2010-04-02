Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0DBG2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:28:48 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:39698 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab0DBG2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hXGD7OqKjhn0ankAJLLoHhI6H1P9m13FbnMVLJQy9dGo/x/C1T6Q++qY0qKjnB1P0x
         Xn9ZkQVz16FZH7D9k/nQtcvG8L5izmMfG8BAIH7dxAx3Q0S3VuAsnCieABU2DcfVPOtY
         DlKZzRJ7h1PGKgzL542fiN+Ql3B7xJ3foNELA=
MIME-Version: 1.0
In-Reply-To: <4BB49B0E.8070306@siemens.com>
References: <4BB49B0E.8070306@siemens.com>
Date: Fri, 2 Apr 2010 09:28:39 +0300
Message-ID: <o2mb6fcc0a1004012328g2b61260bibadbfd8f3d6f87ce@mail.gmail.com>
Subject: Re: [PATCH] proc: Report file name on detected read_proc overflow
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Helight.Xu" <helight.xu@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:09 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> This can help identifying the buggy read_proc handler.

->read_proc is going to be removed, so there is no point.

> -                                      "proc_file_read: Apparent buffer overflow!\n");
> +                                      "proc_file_read: Apparent buffer "
> +                                      "overflow reading \"%s\"!\n",
> +                                      file->f_path.dentry->d_name.name);
