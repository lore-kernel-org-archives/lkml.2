Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2GOKLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:11:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34214 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2GOKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:11:36 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <CAK=Wgbb37rORbu0v-=U0NrNqcvk3FQ5DudW=J1ky32Hgv8+MPQ@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYcySfWMLBRCJ9B38Bew0ELBgORtnJbGgfqfMda_+3q9w@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F86BE47@EXDCVYMBSTM005.EQ1STM.local> <CAK=Wgbb37rORbu0v-=U0NrNqcvk3FQ5DudW=J1ky32Hgv8+MPQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 13:11:15 +0300
Message-ID: <CAK=WgbbsYVLk+Ks69GsOb3BkPsi56Dp+cSsbDReg2M=Nsdj6xw@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 6:14 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Mon, Jul 2, 2012 at 6:11 PM, Sjur BRENDELAND
> <sjur.brandeland@stericsson.com> wrote:
>>> To simplify things, will the below work for you?
>>
>> Looks good, feel free to add my Acked-by
>
> Thanks! I'll queue it up for 3.6.

Applied.
