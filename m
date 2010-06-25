Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0FYN47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:56:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0FYN46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:56:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 9/9] PM / Hibernate: move non-swap code to image.c
Date: Fri, 25 Jun 2010 15:55:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <1275468768-28229-9-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-9-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251555.13125.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010, Jiri Slaby wrote:
> Now, when all the swap-independent code was separated, it's time to
> move it into a separate file called image.c. Although snapshot.c is
> image related too, we want to move the snapshot.c code to mm/,
> because it is rather a memory management so that mm people won't
> forget about hibernation. Hence we don't pollute snapshot.c with
> image processing here.

Makes sense.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---

Rafael
