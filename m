Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217Ab2GYO6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:58:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39586 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030187Ab2GYO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:58:17 -0400
Message-ID: <501009AB.4070408@gmail.com>
Date: Wed, 25 Jul 2012 10:58:51 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Nathan Zimmer <nzimmer@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@gmail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 2/2 v5][resend] tmpfs: interleave the starting node of
 /dev/shmem
References: <1341845199-25677-1-git-send-email-nzimmer@sgi.com> <1341845199-25677-2-git-send-email-nzimmer@sgi.com> <1341845199-25677-3-git-send-email-nzimmer@sgi.com> <20120723105819.GA4455@mwanda> <500DA581.1020602@sgi.com> <alpine.LSU.2.00.1207242048580.9334@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1207242048580.9334@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, what's wrong with the patch below, to replace the current
> two or three?  I don't have real NUMA myself: does it work?
> If it doesn't work, can you see why not?

It works. It doesn't match my preference. but I don't want block your way.
this area is maintained you. please go ahead.

at least, inode bias is better than random.


