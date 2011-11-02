Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1KBXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:02:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54715 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1KBXCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20111102002412.GA14977@suse.de>
References: <cover.1320191327.git.david.decotigny@google.com>
 <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
 <20111102002412.GA14977@suse.de>
From: David Decotigny <david.decotigny@google.com>
Date: Wed, 2 Nov 2011 16:02:24 -0700
Message-ID: <CAG88wWaZZj8k4KmgHdtYUiWQRcVTOaBDS0ik3bqj+VXzm5SQjQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for your feedback.

FYI, this patch was meant to be an answer to a negative feedback I
received when I proposed changing a few module_param(... perm=S_IRUGO)
in forcedeth driver. But I agree the "price to pay" is very low.

Should I drop this patch?

--
David Decotigny



On Tue, Nov 1, 2011 at 5:24 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 01, 2011 at 04:50:35PM -0700, David Decotigny wrote:
>> From: David Decotigny <decot@google.com>
>>
>> With this patch, we allow systems that don't want to pay the price for
>> /sys/module/*/paramaters to be compiled without that feature.
>
> The "price"?  What kind of price is it?  How much memory is really saved
> here?
>
> greg k-h
>
