Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2DWVb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:31:57 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:50030 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2DWVbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:31:55 -0400
Message-ID: <1335216712.2187.17.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 24 Apr 2012 07:31:52 +1000
In-Reply-To: <1335133792.2187.8.camel@shrek.rexursive.com>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <201204221347.52883.rjw@sisk.pl>
	 <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com>
	 <201204222229.47160.rjw@sisk.pl> <4F946B86.4000509@debian.org>
	 <1335133792.2187.8.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 08:29 +1000, Bojan Smojver wrote:
> Hibernation regression fix, since 3.2

Rafael,

Any chance of queuing up this simpler patch for stable? We don't want
people's computers to hang on hibernation when there is a fix, right?

-- 
Bojan

