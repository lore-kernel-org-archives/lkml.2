Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2KSN3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:29:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60388 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2KSN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:29:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353248997-30763-32-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
	<1353248997-30763-32-git-send-email-acme@infradead.org>
Date: Mon, 19 Nov 2012 08:29:09 -0500
Message-ID: <CA+5PVA6uj3f5f9Gp=7Zp8CE+0mP7zgCknqmkUX_ootzDxUXRcA@mail.gmail.com>
Subject: Re: [PATCH 31/32] perf powerpc: Use uapi/unistd.h to fix build error
From: Josh Boyer <jwboyer@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 9:29 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.

This would work for powerpc, but at least s390x and ARM have the same
build issue.  Why would we fix this piecemeal per-arch?

David Howells has a patch that _should_ fix it for all of them at once.
Is there a reason that isn't going in?

josh
