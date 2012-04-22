Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab2DVLvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 07:51:37 -0400
Received: from smtp3.su.se ([130.237.164.77]:59925 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750921Ab2DVLvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 07:51:36 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F93F0B9.3070101@debian.org>
Date: Sun, 22 Apr 2012 13:51:21 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204182330.38156.rjw@sisk.pl> <161dc918-dabe-4c26-a25b-772498282722@email.android.com> <201204221347.52883.rjw@sisk.pl>
In-Reply-To: <201204221347.52883.rjw@sisk.pl>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-22 13:47, Rafael J. Wysocki skrev:
>> > Any chance of it in 3.3.3?
> Nope.
> 
>> > Looks like rc1 of it is already out there...
> I'm going to push it for v3.5, so it will only appear in 3.4.y I guess.

What about 3.2.y?

-- 
Pelle
