Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1K1LVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:21:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:7388 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1K1LVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:21:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,583,1315206000"; 
   d="scan'208";a="89742843"
Date: Mon, 28 Nov 2011 11:33:37 +0000
From: Alan Cox <alan@linux.intel.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 58/62] gma500: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111128113337.590fd517@bob.linux.org.uk>
In-Reply-To: <1322371662-26166-59-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-59-git-send-email-amwang@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Nov 2011 13:27:38 +0800
Cong Wang <amwang@redhat.com> wrote:

> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Looks fine to me although we've just marked the staging driver broken
for a bit. Probably still worth applying so it doesn't get lost.
