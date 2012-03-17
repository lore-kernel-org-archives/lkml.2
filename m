Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2CQXaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 19:30:35 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:41446 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2CQXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 19:30:34 -0400
References: <1331967113.1877.9.camel@shrek.rexursive.com> <201203172157.28760.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201203172157.28760.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: Lower the amount of pages used for buffering on hibernation
From: Bojan Smojver <bojan@rexursive.com>
Date: Sun, 18 Mar 2012 10:30:30 +1100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <5abc90aa-6822-4e6a-9963-ad93bcdc748f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>Looks good, please prepare a signed-off version.

Thanks for reviewing!

This whole thing got me thinking about this problem and I might have a slightly better patch soon, which would not rely on a static precalculation, but rather force BIO chain flush when the number of free pages falls below a certain watermark.

Will keep you posted.

-- 
Bojan
