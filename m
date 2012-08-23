Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2HWXWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:22:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2HWXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:22:01 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU=tTvgdbxSORWLUidmY9m5BRHvBLj=2U1-jqbsBqNLZw@mail.gmail.com>
References: <CALCETrU=tTvgdbxSORWLUidmY9m5BRHvBLj=2U1-jqbsBqNLZw@mail.gmail.com>
Date: Fri, 24 Aug 2012 09:22:01 +1000
Message-ID: <CAPM=9tw+HoEDTr8gwsODUWubbM3SmNitbmj_gO=QcV+0OVeuBw@mail.gmail.com>
Subject: Re: mgag200 hang on boot
From: Dave Airlie <airlied@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 7:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> mgag200 hangs like this on startup, on a Dell PowerEge 12g box.  The
> serial console says:

You can apply this

https://patchwork.kernel.org/patch/1298651/

it should be in stable at some point, I expect its the same bug, it
not get back to me.

Dave.
