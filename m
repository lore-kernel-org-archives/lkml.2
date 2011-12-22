Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1LVR4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:56:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1LVR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:56:53 -0500
Date: Thu, 22 Dec 2011 18:51:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 0/2] block_sigmask() helper function
Message-ID: <20111222175123.GA4895@redhat.com>
References: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Matt Fleming wrote:
>
> Hi Andrew,
>
> Oleg doesn't have a repo on kernel.org yet and suggested that you
> might take these patches through your -mm tree?

Yes, could you take this please? I have no idea when I will restore
my korg account. If ever :/

> Ideally I'd like to
> get these two in for the 3.3 merge window because I've got a bunch of
> other patches that can go through the respective maintainers' trees
> once these two have been merged.

I was surpised by how many bugs there are in arch/ signal code, this
patch helps to factor out the code in the signal-deliver paths.

Oleg.

