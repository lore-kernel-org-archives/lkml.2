Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340Ab1EATUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 15:20:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab1EATUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 15:20:33 -0400
Date: Sun, 1 May 2011 12:25:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: <hpa@zytor.com>, <brgerst@gmail.com>, <tglx@linutronix.de>,
        <mingo@elte.hu>, <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fork: avoid weak function arch_dup_task_struct
Message-Id: <20110501122559.bbf91079.akpm@linux-foundation.org>
In-Reply-To: <1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com>
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
	<1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 16:26:35 +0200 Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> Avoid potential gcc bug by not using a weak function for
> arch_dup_task_struct. Use an #ifdef'ed static function for
> archs that don't have a special arch_dup_task_struct implementation.

The patch is unreviewable (and hence unusable) if you don't describe
this "potential gcc bug".

