Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0KITql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:46:41 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47144 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KITqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MhoeAaL3fEgC9bWvE3wiEHeJg0ZbEi/0CgVBc8QlD2bwUGHykw9byR/L2TfhYcZfyP
         591f7+T/padvywkZooR5Pskxt4YuXsYdNS8YJ8sb6EveTveDNUGLORE1oTXDrFWIMZxT
         9edZES1V59E09Dm/lsf4R6HntSN/IEIGaffa8=
MIME-Version: 1.0
In-Reply-To: <20101109191908.GO5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181525.GH5876@outflux.net>
	<AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
	<20101109191908.GO5876@outflux.net>
Date: Tue, 9 Nov 2010 21:46:39 +0200
X-Google-Sender-Auth: qwRNm9Pb0lR6n1CIPj4-Vbmh31g
Message-ID: <AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 09, 2010 at 09:09:18PM +0200, Pekka Enberg wrote:
>> On Tue, Nov 9, 2010 at 8:15 PM, Kees Cook <kees.cook@canonical.com> wrote:
>> > The XD_DISABLE-clearing side-effect needs to happen on 32bit CPU
>> > start-up as well.
>> >
>> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
>>
>> The patch description here is pretty damn terse. Why do we need the
>> clearing for? Does not clearing XD_DISABLE cause some problem?

On Tue, Nov 9, 2010 at 9:19 PM, Kees Cook <kees.cook@canonical.com> wrote:
> The clearing needs to happen for both 32bit and 64bit, but the 32bit init
> routines were not calling verify_cpu() yet. This adds that path to gain the
> side-effect. (See patch 0 for why clearing XD_DISABLE is important.)

I actually don't see 0/4 or 2/4 on LKML yet. It would be better to
have the rationale in the patch that changes the code for future
reference. The summary email will be lost in the noise much more
easily.

                        Pekka
