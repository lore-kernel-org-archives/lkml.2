Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0D1WCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:02:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56612 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0D1WCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HN1vNAHuNoj9WNVKZGEurGpiKf2uERuYChizZd1XjFXOdhuQxI7cBymNJWmGrR1vtl
         nkBl+HY90kZFwogAJCqToAL1XPXC0aWLJFVt8BfT0peBF3S7OPHT9oSmGeHiqgnMF8aT
         k6lMEz6u+X6Wo67nMrgdUZGipoXPhBOPVvmXI=
MIME-Version: 1.0
In-Reply-To: <1268150038-24318-1-git-send-email-vapier@gentoo.org>
References: <1268150038-24318-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Apr 2010 18:02:15 -0400
Message-ID: <s2w8bd0f97a1004281502r5ad02858zf3e1256ad35d16c8@mail.gmail.com>
Subject: Re: [PATCH] backlight: new driver for the ADP8860 backlight parts
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 11:53, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> The ADP8860 combines a programmable backlight LED charge pump driver
> with automatic phototransistor control.

could you pick this up Andrew ?
-mike
