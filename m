Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2HJMAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:00:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35394 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2HJMA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1208091816240.9631@eggly.anvils>
References: <CAJd=RBAjGaOXfQQ_NX+ax6=tJJ0eg7EXCFHz3rdvSR3j1K3qHA@mail.gmail.com>
	<alpine.LSU.2.00.1208091816240.9631@eggly.anvils>
Date: Fri, 10 Aug 2012 20:00:28 +0800
Message-ID: <CAJd=RBDu5ebAAOuie5yNc8x7vkn7LPfDZZyGzRsCUFNRojWmwQ@mail.gmail.com>
Subject: Re: [patch] mmap: feed back correct prev vma when finding vma
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 9:26 AM, Hugh Dickins <hughd@google.com> wrote:
> On Thu, 9 Aug 2012, Hillf Danton wrote:
>> After walking rb tree, if vma is determined, prev vma has to be determined
>> based on vma; and rb_prev should be considered only if no vma determined.
>
> Why?  Because you think more code is better code?  I disagree.

s/more/correct/

Because feedback is incorrect if we return vma corresponding to
the root node.

Hillf
