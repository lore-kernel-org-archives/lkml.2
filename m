Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902Ab0E0AM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:12:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab0E0AM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:12:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Date: Thu, 27 May 2010 02:13:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
In-Reply-To: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270213.42913.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
> Hello,
> 
> I am trying to build 32 bit kernel image on 64-bit machine but after
> 'make menuconfig' it automatically switches 32-bit to 64-bit.

Try 'linux32 make menuconfig' and 'linux32 make'.

Rafael
