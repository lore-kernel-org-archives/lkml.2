Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2HHW2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:28:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2HHW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:28:06 -0400
Date: Wed, 8 Aug 2012 15:28:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
In-Reply-To: <5017F674.80404@redhat.com>
Message-ID: <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com>
References: <5017F674.80404@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Mauro Carvalho Chehab wrote:

>       [media] radio-shark: New driver for the Griffin radioSHARK USB radio receiver

This one gives me a build warning if CONFIG_LEDS_CLASS is disabled:

ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
