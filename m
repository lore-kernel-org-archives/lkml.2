Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2C2Din (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:38:43 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:41763 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C2Dih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:38:37 -0400
Message-ID: <1332992315.2040.27.camel@shrek.rexursive.com>
Subject: Re: [PATCH v7]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Thu, 29 Mar 2012 14:38:35 +1100
In-Reply-To: <201203282329.11086.rjw@sisk.pl>
References: <1332891672.2040.24.camel@shrek.rexursive.com>
	 <201203282329.11086.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 23:29 +0200, Rafael J. Wysocki wrote:
> OK, I'll take this one for v3.5.

Thanks.

Although, we may need this queued for stable as well. Folks that have
hit page allocation problems during hibernation will test and I will
then let you know.

> Thanks a lot for being persistent!

No trouble at all.

-- 
Bojan

