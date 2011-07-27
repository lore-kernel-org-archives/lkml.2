Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1G0P7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:59:13 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57905 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1G0P7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <201107271722.51179.arnd@arndb.de>
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
	<201107271628.29532.arnd@arndb.de>
	<CAFbHwiRUKEuK_88+yfUpiWnRBgGKBTpH2Fm7EpzW-dJSiwhHLA@mail.gmail.com>
	<201107271722.51179.arnd@arndb.de>
Date: Wed, 27 Jul 2011 16:59:10 +0100
Message-ID: <CAFbHwiQPQVF68=-Z315cE1DOj7bB4zVnnoXV6w3D9891FKi+GA@mail.gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 4:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 27 July 2011, Will Newton wrote:
>> Imagination Technologies META, which is a custom in-house
>> architecture. No immediate plans to upstream unfortunately. :-/
>
> Ah, interesting. We have a few other DSP architectures lined up
> for upstream integration. Let me know when you get there as well.
> Is there a git tree available somewhere?

Not at the moment. It's something I would like to have though.

>> FWIW I checked all the in-tree architectures and it seems everyone
>> else gets this right (although I got a bit lost with tile).
>
> Yes, I think that you get into a lot of other problems if you
> mess up the basic synchronization primitives, so they would have
> noticed at some point.

On the contrary, the system was remarkably stable and the issue only
showed up in one particular driver under heavy load. ;-)
