Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab1FVDE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab1FVDE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:04:58 -0400
Message-ID: <4E015BCE.6090703@redhat.com>
Date: Wed, 22 Jun 2011 11:04:46 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: improve THP printk messages
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-3-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211823310.5205@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106211823310.5205@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 09:23, David Rientjes 写道:
> You're changing a printk() but not fixing the typos in it?

Oh, sorry, I was not aware of that.
