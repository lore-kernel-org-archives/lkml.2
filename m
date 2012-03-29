Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab2C2Tnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:43:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52075 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2C2Tnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <86fwcroo6t.fsf@sumi.keithp.com>
References: <alpine.DEB.2.00.1203290811240.25319@skynet.skynet.ie>
	<86fwcroo6t.fsf@sumi.keithp.com>
Date: Thu, 29 Mar 2012 21:43:41 +0200
Message-ID: <CAFLxGvwRDos2njfoF9wSZcinXRJQ7rUo1UZrPqaw2yC-u0LAkw@mail.gmail.com>
Subject: Re: [git pull] drm intel hibernation fix
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 9:34 AM, Keith Packard <keithp@keithp.com> wrote:
> <#part sign=pgpmime>
> On Thu, 29 Mar 2012 08:14:08 +0100 (IST), Dave Airlie <airlied@linux.ie> wrote:
>
>> Dave Airlie (1):
>>       drm/i915: suspend fbdev device around suspend/hibernate
>

I've reported the issue one year ago and kept the discussion
alive until the problem was found and resolved:
https://lkml.org/lkml/2011/3/23/360

Nevertheless I'm not mentioned with a Reported-by. :-(

-- 
Thanks,
//richard
