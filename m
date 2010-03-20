Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0CTTc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:32:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46713 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0CTTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aNqCZlPgigrS1bMVZvTvTJ9t0IzAaaB0kRTA8Lwmy6iL/VSmNx5wSaXVd4ZLjD7ahf
         XoGvuMYAGj/TNsQMbGaBUmflNhNu1s0FLQ0muPR+wiYaydF6vt3x/ScxVqIiK+4RvKdJ
         vLiwXRj6svFJ0kC2LKpRqQTLH9P9ZX04VV2jM=
MIME-Version: 1.0
In-Reply-To: <5d5443651003201227w27314533w6be3cdd8fb9bf5aa@mail.gmail.com>
References: <4BA358DB.20708@enmesh.se>
	 <167e8a331003192151o593809bbhcda68e284185dd4a@mail.gmail.com>
	 <5d5443651003201227w27314533w6be3cdd8fb9bf5aa@mail.gmail.com>
Date: Sat, 20 Mar 2010 12:32:26 -0700
Message-ID: <167e8a331003201232u38173f3er2fcd64ca5f6cd420@mail.gmail.com>
Subject: Re: input: mt: Software finger tracking in the kernel?
From: Ping Cheng <pinglinux@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Henrik Rydberg <rydberg@enmesh.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:27 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> Another attribute associated with _MT_ is the pressure/capacity.
>> Report this value would offer more room for MT-aware application to
>> add new features.
>
> We have ABS_MT_PRESSURE added recently. I hope you are asking the same.

Great. ABS_MT_PRESSURE is what I meant. I must have looked at an old doc/code.

Ping
