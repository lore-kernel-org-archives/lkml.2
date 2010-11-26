Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0KZKUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:20:18 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61547 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0KZKUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Y3WBQKf8hTIke3enHOihnUMB4Dmzedh3qoCX2zQyst3EwotWfAGfuM3GKE3WbrWEra
         TN33sC3ZFAOP2T1BXT1ttYamnJDmTw0S5G8Vk4vOAB4XFsgKRwJ7VCfJaEmoRwILbgyB
         MxdIUuMcX3nFWVIq0EIzbcXYQAMi7IVhYlWCA=
MIME-Version: 1.0
In-Reply-To: <20101126100915.66112ee7@lxorguk.ukuu.org.uk>
References: <1290765760.6087.3.camel@cai.gentoo> <20101126100915.66112ee7@lxorguk.ukuu.org.uk>
From: microcai <microcai@fedoraproject.org>
Date: Fri, 26 Nov 2010 18:19:55 +0800
X-Google-Sender-Auth: dLTGQXLWuOhKe5cHjf66FEc-9Kc
Message-ID: <AANLkTi=gUrUZv=3=tEhyjtWfwhADLU5heo7+DYTQboQv@mail.gmail.com>
Subject: Re: [PATCH 1/2] Kernel fbcon UNICODE font support
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-console@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>  I know there are most people speaking only English, and never meet
>> non-ASCII characters on console. But, hey , what about others ?
>
> Like the people who have never met Indic languages or half-space using
> languages, or Arabic or right to left/left to right mixed or ...
>
>>  So, here is the solution: Making framebuffer console handle UNICODE font in
>> kernel.
>
> It isn't really a solution - the rendering rules for Unicode are extremely
> complex, this is why things like Pango exist to do it in user space.
>
> Alan
>

Hey,  just support very basic rendering. that should fix most situations.
If ascii fits 90% situations, then this UNICODE support should fit 99%
situations. It don't make console display urgly glyph. Users who want
more complex  can simply choose gnome-terminal or konsole or blablalba
....
This maks it possible to quickly view an UTF-8 text without boring X.
