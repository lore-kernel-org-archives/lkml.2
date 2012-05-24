Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2EXFVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:21:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41438 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EXFV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaPiiXzj2+oeHRa1KrGVrESfxpxpiXOkNPyKWd-oQCbszg@mail.gmail.com>
References: <CAHdPZaPiiXzj2+oeHRa1KrGVrESfxpxpiXOkNPyKWd-oQCbszg@mail.gmail.com>
Date: Thu, 24 May 2012 10:51:29 +0530
Message-ID: <CAHdPZaNwXaOCAfe6ygUPHj0wOoC5kkJpcfpR9kban2_Wn2wfrA@mail.gmail.com>
Subject: Re: question about the failure of eisa_root_register in drivers/eisa/pci_eisa.c
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anybody please .. ?
On Wed, May 23, 2012 at 3:42 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> Hello ,
>
>   If the eisa_root_register fails, the function just returns rather
> than calling the pci_disable_device and return. so we need to use the
> pci_disable_device and return.
>
>
> Please suggest me if i am wrong.
>
> Thanks,
> Devendra.
