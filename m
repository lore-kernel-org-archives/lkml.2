Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0IJBl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:41:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46374 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0IJBl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:41:27 -0400
X-User-Agent: K-9 Mail for Android
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com> <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com> <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com> <1284082229.24986.253.camel@Joe-Laptop>
In-Reply-To: <1284082229.24986.253.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 09 Sep 2010 19:41:46 -0600
To: Joe Perches <joe@perches.com>, Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Message-ID: <e313fc89-de12-41fd-8f36-edd9b5dd6906@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Joe Perches" <joe@perches.com> wrote:

>On Fri, 2010-09-10 at 09:27 +0900, Masayuki Ohtake wrote:
>> > If you incluse ChangeLogs it's easier to follow the development,
>> > thanks.
>> The latest patch has included the following Changelog.
>
>I believe Linus is asking for the same thing as I did.
>
>Some means to track your the changes in your multiple submissions
>of the same files.
>
>Typically, this would be a git repository where people can
>read the delta patches instead of entire unversioned files.

Nah, that's unnecessary overkill.  A short description in the changelog about what has changed between each posted version of the patch is sufficient.  I certainly don't ask anybody else to publish a git tree.

g.

>
>cheers, Joe
>

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
