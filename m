Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459Ab1DPWoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 18:44:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62795 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1DPWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 18:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EQaeoYCRmwhDV/Ezfrm1celzo12bUJSE2BtSosUXeOjzCb0o32CkkOxWa1ZaHm5zrR
         b+3hYkNJgG6t3zwo+iK1aW4Nt5igmZahPN3rvXL3HwbF/4IFpS/o65LqXYKTyJBDi5uP
         vUO4l74vQDfgZ+lbBLl/BwJ8D/A5U9ukCOezo=
MIME-Version: 1.0
In-Reply-To: <4DA9CB83.4050000@gmail.com>
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com> <4DA9CB83.4050000@gmail.com>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Sun, 17 Apr 2011 00:43:34 +0200
Message-ID: <BANLkTi=avo9yvpQ0VRPRv1uroF3ZnJzfAg@mail.gmail.com>
Subject: Re: [Regression] Bluetooth pairing does not work anymore in
 2.6.39-rc3 (works in 2.6.38.3)
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

> I'm wondering if you are hitting what I was hitting a few days ago.. the
> commit below got things working over here:
> (not sure if this is in the stable yet)
> http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a

I checked: I have this commit in -rc3, so it must be something else here.

greetings,

gohai
