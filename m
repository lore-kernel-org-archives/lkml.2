Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0CaGlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:41:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932798Ab0CaGlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:41:20 -0400
Date: Tue, 30 Mar 2010 23:38:51 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-Id: <20100330233851.17370621.akpm@linux-foundation.org>
In-Reply-To: <20100331063546.GB28659@aftab>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
	<1269610800-23847-3-git-send-email-bp@amd64.org>
	<20100330154229.dc8ebd24.akpm@linux-foundation.org>
	<20100331061343.GA28659@aftab>
	<20100330232221.826fe933.akpm@linux-foundation.org>
	<20100331063546.GB28659@aftab>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 08:35:47 +0200 Borislav Petkov <bp@amd64.org> wrote:

> Do you want a relative diff ontop of this patch or
> should I redo the original one?

I don't mind really.  I'll turn it into a delta locally so I can see
what changed.

I've unilaterally decided that all six patches should be merged via the
x86 tree, btw.  They could be split between x86 and cpufreq, but I
suspect there are interdependencies which would make that hard.


