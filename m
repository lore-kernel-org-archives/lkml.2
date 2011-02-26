Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1BZW5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:57:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1BZW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iAXlXAm7wba+c3JnkQdtoGB+iFXT2ERpLH9dzt9Tc90OQTx9dLH8VvqGk4uJjxW778
         ZUwn8YAjrMuTz+EYGfke1X/ZQ7eHDnGyuaCaChvfAf6pEM1it3DWzVUxs5srr1f9ZRfo
         QNfArp1madsvE+ZI0NA6HLE/hCPkClzF83vuc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>
Date: Sat, 26 Feb 2011 17:57:49 -0500
Message-ID: <AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 5:47 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Sat, Feb 26, 2011 at 8:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Why ? Thing should be kept simple. kconfig's job is not to know about
>> the trillion file format which exist in the world, even more if the
>> implementation is made by building a command[0], executing it in a
>> separate process and reading the output. This is the shell's job. What
>> may be useful in the contrary would be to eventually teach kconfig to
>> read from <stdin>.
>
> /proc/config.gz is provided by the kernel and its format is defined by
> kconfig itself which is, as well, part of the kernel (it is not one
> random format from a pool of a trillion), so it will be nice if
> kconfig learns how to read its own configuration from there.
>
your point being ? kconfig is not only used by the Linux kernel, and
you cannot expect the feature to only be used in the cozy Linux kernel
environment.

> kconfig only knows about config files (one format). The fact that it's
> gzipped its irrelevant, any reasonable machine capable of building the
> kernel has gzip installed.
>
again, the average user has no interaction with kconfig directly,
(s)he uses the top level Makefile target at best. The original patch
of Jeff is way better than any hack to read a gzip file from kconfig.
KISS and please don't reinvert the wheel.

 - Arnaud
