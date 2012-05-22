Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2EVMIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:08:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50383 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2EVMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:08:47 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 14:08:46 +0200
Message-ID: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
Subject: Regression on GMA965 - display seems to have slow jump changes in brightness
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've updated to 3.4 kernel, and now I'm noticing slight changes in
brightness on colorful images.
It seems the change is mostly visibly on  'darker' images i.e. it's
not really visible on white background.

When I reboot back to 3.3  kernel - brightness changes are gone - so I
do not suspect hw fault of my T61 display.
I guess once in past there has been already such bug, so this problem
seems to me like reintroducing the same
problem again.

xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
with SNA intel driver build from git repo.
T61, 965GM

Is this a know issue ?
Is bisect needed ?

Zdenek
