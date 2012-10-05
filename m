Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2JEIDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:03:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49132 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2JEID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121004145022.GA73321@intma.in>
References: <fa.90I1W/wmSTgRFXVG67o7Pp3+rKA@ifi.uio.no>
	<fa.Oszo+r/ZqdTxC2FHqqg+CRVMJ5Y@ifi.uio.no>
	<fa.CoxzZZId9dJONv353c+pFG/HO8E@ifi.uio.no>
	<fa.ixJ/7D7BnMK8xp7CwikX7jbmnKU@ifi.uio.no>
	<fa./ubRQE7P/T+ateohnOKdDxOFhL4@ifi.uio.no>
	<fa.lpiFTa5CtuIkUf2Z5eJ0YlsNwYI@ifi.uio.no>
	<20121004145022.GA73321@intma.in>
Date: Fri, 5 Oct 2012 15:03:28 +0700
Message-ID: <CA+i8gKLMtvsR8_aXiNr_Dh8oBw__pSn__ExzRyjG80f4L1u2ng@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Kurt H Maier <khm@sdf.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 9:50 PM, Kurt H Maier <khm@sdf.org> wrote:
> On Wed, Oct 03, 2012 at 07:27:01PM +0000, Al Viro wrote:
>>
>> Al, that -><- close to volunteering for maintaining that FPOS kernel-side...
>>
>
> This would be fantastic.

And that would solve this very much worrying issue [1], quoting:
"(Yes, udev on non-systemd systems is in our eyes a dead end, in case you
haven't noticed it yet. I am looking forward to the day when we can drop
that support entirely.)"

[1] http://lists.freedesktop.org/archives/systemd-devel/2012-August/006066.html
