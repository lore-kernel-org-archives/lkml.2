Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2LYMFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 07:05:07 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61644 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2LYMFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 07:05:05 -0500
MIME-Version: 1.0
In-Reply-To: <535932623.34838584.1356410331076.JavaMail.root@redhat.com>
References: <1621091901.34838094.1356409676820.JavaMail.root@redhat.com>
	<535932623.34838584.1356410331076.JavaMail.root@redhat.com>
Date: Tue, 25 Dec 2012 20:05:04 +0800
Message-ID: <CAJd=RBB9Tqv9c_Wv+N8yJOftfkJeUS10vLuz14eoLH1eEtjmBQ@mail.gmail.com>
Subject: Re: kernel BUG at mm/huge_memory.c:1798!
From: Hillf Danton <dhillf@gmail.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        mgorman@suse.de, hughd@google.com,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 12:38 PM, Zhouping Liu <zliu@redhat.com> wrote:
> Hello all,
>
> I found the below kernel bug using latest mainline(637704cbc95),
> my hardware has 2 numa nodes, and it's easy to reproduce the issue
> using LTP test case: "# ./mmap10 -a -s -c 200":

Can you test with 5a505085f0 and 4fc3f1d66b1 reverted?

Hillf
