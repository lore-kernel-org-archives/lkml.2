Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2HXAyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:54:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64922 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2HXAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tw+HoEDTr8gwsODUWubbM3SmNitbmj_gO=QcV+0OVeuBw@mail.gmail.com>
References: <CALCETrU=tTvgdbxSORWLUidmY9m5BRHvBLj=2U1-jqbsBqNLZw@mail.gmail.com>
 <CAPM=9tw+HoEDTr8gwsODUWubbM3SmNitbmj_gO=QcV+0OVeuBw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Aug 2012 17:54:01 -0700
Message-ID: <CALCETrUcX5PZeovQ0qTAATb-Vpgp0XOk_FJJACeeNY+reAg5Zg@mail.gmail.com>
Subject: Re: mgag200 hang on boot
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 4:22 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Aug 24, 2012 at 7:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> mgag200 hangs like this on startup, on a Dell PowerEge 12g box.  The
>> serial console says:
>
> You can apply this
>
> https://patchwork.kernel.org/patch/1298651/

Works for me.  Thanks.

--Andy
