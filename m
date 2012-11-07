Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2KGTbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:31:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2KGTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:31:08 -0500
Date: Wed, 7 Nov 2012 11:31:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V2 0/2] Provide more precise dump info for memcg-oom
Message-Id: <20121107113107.d91eba43.akpm@linux-foundation.org>
In-Reply-To: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Nov 2012 16:40:02 +0800
Sha Zhengju <handai.szj@gmail.com> wrote:

> When memcg oom is happening the current memcg related dump information
> is limited for debugging. The patches provide more detailed memcg page statistics
> and also take hierarchy into consideration.

Within the changelogs, please include a sample of the proposed output
so we can properly review the proposal.

Also it would be useful to provide some justification for the decisions
in this patch: which data is displayed and, particularly, which is not?
Why is the displayed information useful to developers, etc.

