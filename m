Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1CRW3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:29:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47830 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab1CRW3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=RZcJqCruPVm8CnGpGIfrPj6L3sP5wS91Z+z+Ji1O8qhdOlY2OZ+qWKsNSM0SX7GXSK
         tAPb8wDNL0TA4LrsvoCq+NrpRtBo6ZOHP0kytUSrhKdTlJJcw8pfyjxiMhsX4ysGHV4q
         0V6RYPoTNfm5v99+diX4orge9mqNF4ye9seKw=
MIME-Version: 1.0
In-Reply-To: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 15:29:26 -0700
X-Google-Sender-Auth: _sWpiyd-btKIKuzoA2XE0QIj9no
Message-ID: <AANLkTinVRMr2D6oKAS0xQjBcG=OQyUMnoYDLMBR385rq@mail.gmail.com>
Subject: Re: [RFC 0/4] sdhci: few patches for ENE 712 support
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vmehta@atheros.com, naveen.singh@atheros.com, kvalo@adurom.com,
        j@w1.fi, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 3:11 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> I was pulled in to help with ath6kl development work. As part
> of this I was given some PCI "ENE" SDHCI card which can I can slap
> on to my desktop. I was then given this dump of patches to apply
> to sdhci code to get it to work:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath6kl/2011/03/18/sdhci-orig.patch

> I prefer code upstream though so here is my split and cleanup
> of these patches. I've tested it with my ENE card. Since I am
> new to SDHCI I would prefer someone with more experience review
> these chagnes and the respective commit log messages. I've
> tried to make sense of them as best as I can. Unfortunately
> I was not given any explanation to these changes except the
> patch I got so I tried to make the best of it.

  Luis
