Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab1DXVUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:20:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45448 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab1DXVUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=aQThKE1fHejPKlW/1myacRBDxy8NNeZLTl/LaOPwSZpjDRfKbDFi88gSXixlKL9yPD
         Zm1ZuEa85XXBLo1iLmm5Ijd6pI8tpx+/7/8Z1UWAoBb+S+Ji6x0chCBQp7dpG4FX0tlV
         ZROKtxBRjiTPwNM75V85qkVkzy21cBPgthfFs=
MIME-Version: 1.0
In-Reply-To: <4DB491D8.6040600@verizon.net>
References: <4DB491D8.6040600@verizon.net>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 24 Apr 2011 17:19:43 -0400
X-Google-Sender-Auth: vOSkPfKvVx6oAl4WNAkN2MWUOZM
Message-ID: <BANLkTi=j2PgE0PcTF-=dgHMEe_QuSHkxOA@mail.gmail.com>
Subject: Re: [PATCH] arch: blackfin: use cc-cross-prefix to set CROSS_COMPILE
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 17:10, Peter Foley wrote:
> This patch updates the blackfin Makefile to use cc-cross-prefix
> to only set CROSS_COMPILE if bfin-uclinux-gcc exists.

i'm not sure this is useful.  if bfin-uclinux- doesnt exist, it's
going to use the native gcc, and there is no native gcc for Blackfin
targets (since it's a nommu arch).  getting a missing bfin-uclinux-gcc
error is a lot more useful than the native compiler rejecting Blackfin
insns.
-mike
