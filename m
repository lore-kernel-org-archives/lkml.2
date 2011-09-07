Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab1IGWuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab1IGWue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:50:34 -0400
Date: Wed, 7 Sep 2011 15:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Serge Hallyn <serge@hallyn.com>
Cc: segooon@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, dhowells@redhat.com,
        ebiederm@xmission.com, rdunlap@xenotime.net,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 01/15] add Documentation/namespaces/user_namespace.txt
 (v3)
Message-Id: <20110907155024.42e3fe27.akpm@linux-foundation.org>
In-Reply-To: <1314993400-6910-4-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
	<1314993400-6910-4-git-send-email-serge@hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Sep 2011 19:56:26 +0000
Serge Hallyn <serge@hallyn.com> wrote:

> +Note that this userid mapping for the VFS is not yet implemented, though the
> +lkml and containers mailing list archives will show several previous
> +prototypes.  In the end, those got hung up waiting on the concept of targeted
> +capabilities to be developed, which, thanks to the insight of Eric Biederman,
> +they finally did.

not-yet-implemented things worry me.  When can we expect this to
happen, and how big and ugly will it be?

I'm not seeing many (any) reviewed-by's on these patches.  I could get
down and stare at them myself, but that wouldn't be very useful.  This
work goes pretty deep and is quite security-affecting.  And network-afecting.
Can you round up some suitable people and get the reviewing and testing happening
please?

