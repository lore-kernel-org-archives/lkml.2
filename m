Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2DASwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:52:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42680 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2DASwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:52:14 -0400
MIME-Version: 1.0
In-Reply-To: <4F755350.4070000@st.com>
References: <4F755350.4070000@st.com>
Date: Sun, 1 Apr 2012 20:52:13 +0200
Message-ID: <CACRpkdZjRWxfvt8=9rVr3ojtszf0hWE2wECuNKnA0S3g4M1hrw@mail.gmail.com>
Subject: Re: pinctrl: Query regarding SPEAr patches.
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 8:31 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> i don't want to keep all
> code in drivers/pinctrl directly. Instead i want to add following
>
> - drivers/pinctrl/spear/
>        - spear.c[h]
>        - spear3xx.c[h]
>        - spear300.c
>        - spear310.c
>        - spear320.c
>        - spear13xx.c[h]
>        - spear1310.c
>        - spear1340.c
>
> Would this be acceptable to add a folder inside pinctrl?

Sure, no problem. How many million lines is it? :-)

Linus Walleij
