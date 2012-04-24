Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2DXMLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:11:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51513 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2DXMLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:11:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120423154342.GB23990@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
	<20120423154342.GB23990@kroah.com>
Date: Tue, 24 Apr 2012 14:11:09 +0200
Message-ID: <CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 5:43 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 23, 2012 at 09:16:36AM +0200, Linus Walleij wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>
>> If !dev->class, device_move() does not respect the dpm_order.
>> Fix it to do so.
>>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
>> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
>> [Fixed a small dangling label compile warning]
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/base/core.c |   36 ++++++++++++++++++------------------
>>  1 file changed, 18 insertions(+), 18 deletions(-)
>
> Is this a problem in 3.4?  Older kernels?  Or can it wait for 3.5?

Rabin said earlier that it could wait for 3.4 atleast.

Yours,
Linus Walleij
