Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1GVBaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:30:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43945 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1GVBap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110721170122.1fd4a06e.rdunlap@xenotime.net>
References: <20110721170122.1fd4a06e.rdunlap@xenotime.net>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 21 Jul 2011 21:30:25 -0400
X-Google-Sender-Auth: aJjyjCmqnY-4-CRiAcwyNLHjxLw
Message-ID: <CAMjpGUf7v3P9ixQa5Z90gCSrEZrws_dXvtxF68gUB4G40oosgQ@mail.gmail.com>
Subject: Re: [PATCH] firmware: sigma.c needs MODULE_LICENSE
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 20:01, Randy Dunlap wrote:
> Fix module tainting message:
> sigma: module license 'unspecified' taints kernel.

odd ... not sure how that was missed

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
