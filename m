Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2B2EY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 23:24:27 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53807 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2B2EY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 23:24:26 -0500
Date: Wed, 29 Feb 2012 13:30:47 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] KVM: srcu-less dirty logging
Message-Id: <20120229133047.40d6da57.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F4CA66F.8090109@redhat.com>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
	<1330003524.11248.11.camel@twins>
	<4F4CA66F.8090109@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> There will be an inversion for sure, if __put_user() faults and triggers
> an mmu notifier (perhaps directly, perhaps through an allocation that
> triggers a swap).

Ah, I did not notice that possibility.

Thanks,
	Takuya
