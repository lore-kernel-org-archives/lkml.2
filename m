Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2IJNxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:53:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64822 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2IJNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:53:16 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.9.91]
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923B9DB3227@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C1057923B924C92D@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbZLjQVYFHcTkb+nDpYZx3qkWp=wQmOqOpMHCxroceTNpg@mail.gmail.com> <81C3A93C17462B4BBD7E272753C1057923B9DB3227@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Sep 2012 16:52:55 +0300
Message-ID: <CAK=WgbaK_k=d8Qcz5VfXndkPPSgp-ZbFYZ-kV5BDPNgDJvX_6A@mail.gmail.com>
Subject: Re: Remoteproc: Translating between host and device addresses.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Sep 10, 2012 at 4:07 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> But the vring descriptor table will still contain the host's physical address for the
> buffers, right?
> So how can the device then find the device-address of these buffers if we don't
> use an IOMMU and have no address translation from host-physical-address
> to device-address?

Sorry, you're asking very specific questions about something no one
implemented nor really designed yet :)

Do you have a specific problem you're trying to address ?

I'd be happy to help.

Thanks,
Ohad.
