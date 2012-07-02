Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2GBIP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab2GBIPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:15:24 -0400
Message-ID: <4FF15898.4080506@redhat.com>
Date: Mon, 02 Jul 2012 10:15:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: Re: [PATCH v2 2/2] msync: start async writeout when MS_ASYNC
References: <1339773179-31210-1-git-send-email-pbonzini@redhat.com> <1339773179-31210-3-git-send-email-pbonzini@redhat.com> <20120622142627.b6184eda.akpm@linux-foundation.org>
In-Reply-To: <20120622142627.b6184eda.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/06/2012 23:26, Andrew Morton ha scritto:
>> If the application does not want to start I/O, it can simply call msync
>> with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
>> be on a reasonable implementation.
> 
> Using MS_INVALIDATE is a bit of a hack.

Right, you could use flags == 0.

I'm not _that_ attached to this patch, I'll send a v3 of the other one
and drop this one.

Paolo
