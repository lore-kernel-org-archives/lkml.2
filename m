Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2LDJ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:27:19 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44349 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LDJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121204083655.GA21235@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
	<CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
	<20121204083655.GA21235@fancy-poultry.org>
Date: Tue, 4 Dec 2012 19:27:15 +1000
Message-ID: <CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
From: Dave Airlie <airlied@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 6:36 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 03.12.2012, devendra.aaru wrote:
>
>> Add more CC's
>
> Thanks!
>
> This is a real showstopper for me, it occurs in every session now.
> Booting with "i915.i915_enable_rc6=0" doesn't help

https://bugs.freedesktop.org/show_bug.cgi?id=55984

intel guys are as lost as anyone.

Dave.
