Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1BJErR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:47:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38624 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755585Ab1BJErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:47:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xI3gmWQUxN6cf8zwRTgaI26geVQHfYAZO+fLtYf
	FM2cmAjRuWvNkc
Subject: Re: [BUG] soft lockup while booting machine with more than 700
 cores
From: Mike Galbraith <efault@gmx.de>
To: raz ben yehuda <raz@scalemp.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <1297236453.2756.9.camel@raz.scalemp.com>
References: <1297236453.2756.9.camel@raz.scalemp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 05:47:12 +0100
Message-ID: <1297313232.7996.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 09:27 +0200, raz ben yehuda wrote:
> Mingo Hello
> 
> Bellow is a boot of a 2.6.32.19 kernel over a machine with more than 700 cores.

A couple comments.

1. A lot of scheduler fixes were backported since then, so trying the
latest .32 stable kernel is worth investigating.

2. Nasty thing with huge boxen is that they can get into big trouble
with the rt throttle during boot.  You might try defaulting that thing
to off until booted.  Dunno if this box is big enough to hit that, 2048
cores definitely is.

	-Mike


