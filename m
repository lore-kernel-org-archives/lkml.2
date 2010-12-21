Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0LUSBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:01:23 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:63162 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LUSBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=NR+HMmBZRepZYG6suLQc+fLivtpra0+Ko8cpd8C8qOsjY6XuE9OujUCQkWD/CGmoPT
         c/CvZrPniRQ0Ldk/9zBI3xriLZ4HGeiNeGOk7ehG0sxah7Ob32B58M4ykrGIvvh+ZIwY
         b75M9l0lt9h0FemsyBnqrk9Ar1YmEObD98Vp4=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/6] Minor cleanups & fixes for perf-probe(1)
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
	<4D10A795.9040809@hitachi.com>
Date: Tue, 21 Dec 2010 19:01:06 +0100
In-Reply-To: <4D10A795.9040809@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 21 Dec 2010 22:11:49 +0900")
Message-ID: <m3aajzc8f1.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> (2010/12/20 23:17), Franck Bui-Huu wrote:
>> 
>> This small patchset is just some random cosmetic cleanups I did when
>> starting to read perf-probe(1) stuffs.
>
> Basically the contains of this series are good to me.
> (I've sent my comments)
> however, it's less comments on each patch. Please explain
> what you did in each patch! (not only on the subject line:-))

Ok. I thought those changes in this serie was obvious enough.

> Thank you,

You're welcome.

-- 
		Franck
