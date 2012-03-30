Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125Ab2C3Qw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:52:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2C3QwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwRDos2njfoF9wSZcinXRJQ7rUo1UZrPqaw2yC-u0LAkw@mail.gmail.com>
References: <alpine.DEB.2.00.1203290811240.25319@skynet.skynet.ie>
 <86fwcroo6t.fsf@sumi.keithp.com> <CAFLxGvwRDos2njfoF9wSZcinXRJQ7rUo1UZrPqaw2yC-u0LAkw@mail.gmail.com>
From: Eugeni Dodonov <eugeni@dodonov.net>
Date: Fri, 30 Mar 2012 13:51:40 -0300
X-Google-Sender-Auth: o4MItmPUc7uP8XDsvIItovL_0Qo
Message-ID: <CAC7Lmns_vHwt7Y8j84OcG+S5LE28Q4iOxYMtFYua_1wea7abtw@mail.gmail.com>
Subject: Re: [git pull] drm intel hibernation fix
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 16:43, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Mar 29, 2012 at 9:34 AM, Keith Packard <keithp@keithp.com> wrote:
>> <#part sign=pgpmime>
>> On Thu, 29 Mar 2012 08:14:08 +0100 (IST), Dave Airlie <airlied@linux.ie> wrote:
>>
>>> Dave Airlie (1):
>>>       drm/i915: suspend fbdev device around suspend/hibernate
>>
>
> I've reported the issue one year ago and kept the discussion
> alive until the problem was found and resolved:
> https://lkml.org/lkml/2011/3/23/360

For the historical purposes, I think this would also fix
https://bugs.freedesktop.org/show_bug.cgi?id=35648 and
https://bugs.freedesktop.org/show_bug.cgi?id=40241 as well.

-- 
Eugeni Dodonov
