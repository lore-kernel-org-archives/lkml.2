Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1ARKVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:21:25 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52800 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1ARKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oaNMDowv/h6OBbod4mcymHxyYnpBUaT+9vzfGYjjAMbttV7sS2afiRr12FP5GACJrW
         NSzNqg4BOi3uNLEscLJt5Hmamasv9TRW4DbWY+C0vVT4K2ZBBZ+FUuxWb17SHAlQJzX3
         +UuUaKSyMLyJN94iVW79E1UlvatbFyUIuLFJg=
MIME-Version: 1.0
In-Reply-To: <4D354752.3030401@samsung.com>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
	<AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
	<20101209160157.GA28586@void.printf.net>
	<AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com>
	<20101211192320.GA24430@void.printf.net>
	<AANLkTik7cMwgwXR1zK44HXC+1YtzpU3_zW2GUjcBMi8X@mail.gmail.com>
	<4D354752.3030401@samsung.com>
Date: Tue, 18 Jan 2011 10:21:23 +0000
Message-ID: <AANLkTi=SEXYk9B6N6RGmLKAx_QF6sybgHMVVpEo8mcp8@mail.gmail.com>
Subject: Re: [PATCH v4] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 7:54 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Will.
>
> I have some question...i'm testing dw_mmc in our environment.
> but i didn't understand pdata->init(?)...what initialize in there?

In most of our platforms init is empty so I guess it would be fine to
change that code to ignore a null init pointer. An example of one of
the things we do use the init function for is to switch pins to GPIO
to handle card detect.
