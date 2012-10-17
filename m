Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2JQOep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:34:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36711 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2JQOeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:34:44 -0400
MIME-Version: 1.0
X-Originating-IP: [89.162.225.122]
In-Reply-To: <CAEswnZjKo=JnGWTV1iS9JNy9kZf1LCQ2xVTNj6oJ0H0BbRA57Q@mail.gmail.com>
References: <CAEswnZjKo=JnGWTV1iS9JNy9kZf1LCQ2xVTNj6oJ0H0BbRA57Q@mail.gmail.com>
Date: Wed, 17 Oct 2012 17:34:43 +0300
Message-ID: <CAEswnZjcUaxM1oGVuUUm9Lsx_j6tTyyx2gM+iAE7TywQy_v+6w@mail.gmail.com>
Subject: Re: The screen goes white on blanking in 3.7-rc1
From: Yaroslav Fedevych <yaroslav@fedevych.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have bisected the code and git tells me the first faulty commit is
f3728734ba78310525bf4a361c7787c7c6fa5d40.
Apparently

(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=f3728734ba78310525bf4a361c7787c7c6fa5d40)

Apparently, my machine has Atom BIOS but still needs legacy backlighting.
