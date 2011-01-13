Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1AMBTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:19:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1AMBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=CD9yH9LZmdbj9Q0sNremahtkJdnjJY25MrfZENVwNh4FU6wa5eHOO6cs2B9ainoNVI
         J4anCfmHEGczss+7SVvkMvzGnQ621uRzi+IRNjnEhcYB5Y7hTL1p8CCkg8rmYCIvRJxV
         1N2aWHF/JC3zdDtVbL1CLfpinB8wO/qzlKFjk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=PRg31io9=+i8xYBrn+=ny52tVHW4bLwwiG6tQ@mail.gmail.com>
References: <AANLkTi=PRg31io9=+i8xYBrn+=ny52tVHW4bLwwiG6tQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 17:18:50 -0800
Message-ID: <AANLkTi=9BGupP0sOafQpyMpccYo+fqCY7n6AEH7Wqnn8@mail.gmail.com>
Subject: Re: compat-wireless-2.6.37-4 is out
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 5:11 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Thanks to Hauke for his fixes for this release.
>
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-4.tar.bz2
> sha1sum: e1b6432ce9e6738e320334b26e4adb68d3dd2a80
>
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-4-sn.tar.bz2
> sha1sum: 54b8d777287fdcc7a716d71cfb21884f1ae07157
>
> http://wireless.kernel.org/en/users/Download/stable

Oh and here are the code stats for this release:

compat-wireless code metrics

    739767 - Total upstream lines of code being pulled
      2153 - backport code changes
      1901 - backport code additions
       252 - backport code deletions
      6386 - backport from compat module
      8539 - total backport code
    1.1543 - % of code consists of backport work
       216 - Code changes brought in from pending-stable
       137 - Code additions brought in from pending-stable
        79 - Code deletions brought in from pending-stable
    0.0292 - % of code being cherry picked from pending-stable
       114 - Code changes brought in from linux-next
       102 - Code additions brought in from linux-next
        12 - Code deletions brought in from linux-next
    0.0154 - % of code being cherry picked from linux-next

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.37
compat-wireless release: compat-wireless-v2.6.37-4-sn

  Luis
