Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2CNAHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:07:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38686 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2CNAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <4F5FCF6E.6060403@comcast.net>
References: <4F5FCF6E.6060403@comcast.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Mar 2012 17:06:39 -0700
X-Google-Sender-Auth: FzoeNsWN3fjJxXRqQ5D0LKZYMuQ
Message-ID: <CA+55aFySHdJ_LM4N7UhWektRoGK9f4+18=8xr3bMgK4gHuMqEg@mail.gmail.com>
Subject: Re: [GIT PULL] arch/tile update for 3.3
To: Chris Metcalf <cdmetcalf@comcast.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 3:51 PM, Chris Metcalf <cdmetcalf@comcast.net> wrote:
>
> These include a couple of queued-up minor bug fixes from the community, a fix
> to unbreak the sysfs hooks in tile, and syncing up the defconfigs.

Ugh. When doing defconfigs, please try to use the new minconfig
machinery to generate a somewhat sane config file, instead of one that
contains everything.

They get smaller, and actually way more relevant too.

             Linus
