Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2CEWJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:09:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57761 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2CEWJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:09:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.100.33 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203051856130.31585@skynet.skynet.ie>
References: <alpine.DEB.2.00.1203051856130.31585@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Mar 2012 14:09:13 -0800
X-Google-Sender-Auth: waJyQW0ZyeCnEx-fY_SDN970c3c
Message-ID: <CA+55aFw6w85_6wCTcB_AvXnRgFYhkB8rxpe9FOei3j0ZpGf0FQ@mail.gmail.com>
Subject: Re: [git pull] drm gma500 fix
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:57 AM, Dave Airlie <airlied@linux.ie> wrote:
>
>  git://people.freedesktop.org/~airlied/linux drm-fixes

Hmm. Is freedesktop.org having trouble?

I got

  fatal: unable to connect to people.freedesktop.org:
  people.freedesktop.org[0: 131.252.210.176]: errno=Connection refused

and an the third try (I started stracing it to see what was up with
that "0:" part) it just hung at the connect. And a couple of times it
connected but then got reset.. So I perversely started trying to see
if it's coming alive.

And then it finally started working - but now I'm getting "Already up-to-date."

                Linus
