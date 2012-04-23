Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2DWKIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:08:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:62931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab2DWKIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92031825"
Date: Mon, 23 Apr 2012 11:23:22 +0100
From: Alan Cox <alan@linux.intel.com>
To: Kristoffer Eriksson <kristoffer.ericson@gmail.com>
Cc: =?ISO-8859-1?B?SOV2YXIgTvh2aWs=?= <havar.novik@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Bug reports on the psb-gfx driver
Message-ID: <20120423112322.40b734d9@bob.linux.org.uk>
In-Reply-To: <4F93D373.6050704@gmail.com>
References: <CAJqTQGEe6rGw4_f-7o2DUZs1J9a=pACuX4KYkLfA0_McMC2Ukg@mail.gmail.com>
	<4F93D373.6050704@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012 11:46:27 +0200
Kristoffer Eriksson <kristoffer.ericson@gmail.com> wrote:

> Greetings,
> 
> Please try 3.4 and see if the issue remains. Currently running
> 3.4-RC3 and cant see it happening at all.

Interesting. Guillaume Clements also root caused it on his system and
sent a patch to dri-devel. That is also probably worth trying.

Alan
