Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1A3IxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 03:53:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36221 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1A3IxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 03:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jZOYtDb2OOoZOLhNHzjW/l6Zc9lVJPeW40j51r+KR5IFaVVH8+2ErrjtNmNN3gJ6kN
         5oPD04eQDmYbq0kQrNsZXCQkpUKRg1pJcCQNOnQHTdOcwwqu1DCTmjAZrfuYNK7HhGi8
         eebif69BXTG88jBucml88QFmi04C1xAbsox/4=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Date: Sun, 30 Jan 2011 08:52:47 +0000
User-Agent: KMail/1.9.10
Cc: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>
References: <20110123011221.GB1805@nowhere> <EB643972-4918-4B89-B325-59D03648F2F9@tuebingen.mpg.de> <AANLkTikLTuxYsHUHO3hdSrc_9rSBgmiyePHs6D=7VzjK@mail.gmail.com>
In-Reply-To: <AANLkTikLTuxYsHUHO3hdSrc_9rSBgmiyePHs6D=7VzjK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101300852.47834.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 January 2011, Hugh Dickins wrote:

<snip>
> Yes, that's the problem that's fixed by the little revert patch I
> posted last time.
> Sorry, this thread started out with other problems, then I asked Chris
> if this might also be an i915 issue.
>

My problem is fixed now, so the thread is all yours :)

Good luck

Chris (Clayton)

<snip>

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
