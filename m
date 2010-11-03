Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0KCP0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:26:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61996 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0KCP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UWU0PpHeF7UpuTDwPajBF+WIqrzIEVdw+rIWxFxW2Qhd4mv1lgavUWa15MEtwGoOFG
         UhngaVEie1IuPJdSCuIT28gky6ipAlNCHo2cf1MxX+mE6+/SGB+exaZ1fa6SauKhG0rz
         7vGQbVWLaMv7DV6aAZyOX8Ydai8nr+Rt4G38E=
MIME-Version: 1.0
In-Reply-To: <20101103162042.297958c3@schatten.dmk.lab>
References: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
	<1288785873-16519-1-git-send-email-florian@mickler.org>
	<20101103162042.297958c3@schatten.dmk.lab>
Date: Wed, 3 Nov 2010 16:26:44 +0100
Message-ID: <AANLkTim=L_J4BF9Zxkzqme-Rj77-MTiT0mGR5hp+t0xW@mail.gmail.com>
Subject: Re: [PATCH] checkpatch.pl: fix CAST detection to not screw with
 parens handling
From: Audun Hoem <audun.hoem@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/10, Florian Mickler <florian@mickler.org> wrote:
> On Wed,  3 Nov 2010 13:04:33 +0100
> Florian Mickler <florian@mickler.org> wrote:
>
>> Casts have to be handled after the last type that is followed by an
>> opening parenthesis is handled.
>
> That is the wrong fix. I realized now that with that patch we would
> not claim anything as a CAST anymore. Better is probably to only claim
> a CAST if av_pending is not set. Andy, would that work? It seems to be
> alright... Do you have some tests for checkpatch?
>
> Testing it with the reported line and some other random samples it
> seems to be alright.
>

Probably good enough of a test to try it on random kernel code.
