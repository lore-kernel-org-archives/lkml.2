Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0CTEvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:51:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56988 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab0CTEvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Vuahmk2EsCM8d22y2eitQmWATJlGf8M/fes1ziQKfT5XiWxDeV/Hbs3yS6A6DuPU0L
         M9NLzC20DvDGQG5RX8TOELK0aHpoP3GXgUxQ4YWuRCjFIndDyCq6ZNmuMbnDcaVdg1w8
         SAO6lRa6vujSocdCokdis7k2664oxP9eDiEU8=
MIME-Version: 1.0
In-Reply-To: <4BA358DB.20708@enmesh.se>
References: <4BA358DB.20708@enmesh.se>
Date: Fri, 19 Mar 2010 21:51:22 -0700
Message-ID: <167e8a331003192151o593809bbhcda68e284185dd4a@mail.gmail.com>
Subject: Re: input: mt: Software finger tracking in the kernel?
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@enmesh.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 3:58 AM, Henrik Rydberg <rydberg@enmesh.se> wrote:
> Hi Dmitry,
>
> there is an ongoing discussion about adding multitouch to X
> (http://lists.x.org/archives/xorg-devel/2010-March/006206.html), which is
> beginning to take on more solid form.
>
> One of the suggestions emerging from that discussion is to add the software
> finger tracking to the kernel. Back in summer 2009 when I thought about this, I
> disregarded it as being too experimental. I have since then reconsidered,
> starting to think it really is the right place.
>
> The MT protocol allows applications to take advantage of multi-contact hardware,
> but leaves the problems of finger tracking and filtering to the user. Arguably,
> no application can make good use of MT without these, so the problem is pushed
> forward, in this case to evdev or equivalent.
>
> The knowledge of signal-to-noise ratios and prior input states resides in the
> kernel. Because of this, the finger matching and filtering would naturally
> reside within the kernel.
>
> So, if there were to appear patches to include matching in the input core, would
> you consider them? :-)

I support the idea to add a tracking ID and a filter to _MT_.  I'd
also like to make the filtering method more "device driver developer"
friendly, i.e., give the developer the option to turn the filter on or
off.  If you plan to use a constant for the filtering method, please
allow the developer to choose that constant too.

Another attribute associated with _MT_ is the pressure/capacity.
Report this value would offer more room for MT-aware application to
add new features.

Ping
