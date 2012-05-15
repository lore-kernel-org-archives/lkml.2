Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965970Ab2EORRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:17:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:61811 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815Ab2EORRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100394666"
Message-ID: <4FB28FA2.8090308@linux.intel.com>
Date: Tue, 15 May 2012 10:17:22 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hannes Reinecke <hare@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
References: <1337079889-62380-1-git-send-email-hare@suse.de> <20120515111255.GJ32036@redhat.com> <4FB23C09.7060300@suse.de> <20120515115917.GK32036@redhat.com> <20120515150015.5bf17aea@pyramind.ukuu.org.uk> <20120515143644.GD6948@redhat.com> <20120515161439.00e2de3c@pyramind.ukuu.org.uk> <20120515154641.GI6948@redhat.com>
In-Reply-To: <20120515154641.GI6948@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 08:46 AM, Gleb Natapov wrote:
> There is Phoenix spec 3.0 and there are T13 EDD3.0/4.0. They are
> incompatible and you can't tell which one specific BIOS actually use.
> Everything is correct till now?

You can by the data length.

But yes, there is Phoenix 3.0 (1998), T13 3.0 (2004) and T13 4.0 (2010),
although the latter seems to be stalled in final draft; according to the
T13 logs it went through final ballot resolution but doesn't seem to
have actually been published, unless it got merged into another document
(which is possible).

	-hpa
