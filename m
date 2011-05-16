Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab1EPMEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:04:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63657 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1EPMEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	<AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
	<1300787404.8008.116.camel@groo>
	<BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
Date: Mon, 16 May 2011 14:04:09 +0200
Message-ID: <BANLkTikrXb7h_iG+xOvFPozT6w5Nj8nJKw@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Govindraj <govindraj.ti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 2:17 PM, Govindraj <govindraj.ti@gmail.com> wrote:
> On Tue, Mar 22, 2011 at 3:20 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:
>> Hi,
>>
>> On Mon, 2011-03-21 at 09:16 +0100, ext Linus Walleij wrote:
>>> 2010/12/14 Carlos Chinea <carlos.chinea@nokia.com>:
>>>
>>> > Here you have the fourth round of the HSI framework patches.
>>>
>>> I'd like to notify that this out-of-tree framework is also in use for
>>> the ST-Ericsson
>>> Ux500s, and we've had great success with it. You can add my:
>>>
>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>
>
> Hi Carlos,
>
> Will you posting a next version of HSI framework.
>
> I am planning to adapt omap-hsi driver to this framework.

I was sort of asking the same thing.

I expected this to be queued up for 2.6.40 so we don't proliferate
out-of-tree drivers :-(

If Nokia will not pursue this patch set then tell me and Govindraj
and we can surely take it over.

Linus Walleij
