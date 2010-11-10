Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0KJVPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:15:55 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64692 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab0KJVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=BU0EAftzWrGSSoIeF6eKrySx0f/V8zLXL7eNMQ3IinFd/kPwWgZbd/XIhPJS905FD2
         QvKEYr7yHtx3Xtr2En5KgxW3UnWz4wi+4r2R05HSHOHw0yyJ+jtMHg1rWix8X8uqVwYC
         rPtAHgnlnUQOfevAdSTn+tXSUlWF61MMwMOyw=
From: Ben Gamari <bgamari@gmail.com>
To: Borislav Petkov <bp@amd64.org>, acme@infradead.org, fweisbec@gmail.com,
        mingo@elte.hu, peterz@infradead.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
In-Reply-To: <1288885016-18295-4-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org> <1288885016-18295-4-git-send-email-bp@amd64.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 10 Nov 2010 16:15:47 -0500
Message-ID: <87lj50vq0s.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Nov 2010 16:36:39 +0100, Borislav Petkov <bp@amd64.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add the necessary glue to enable the mce_record tracepoint on boot
> turning it into a persistent event. This exports the MCE buffer
> read-only to a userspace daemon which will hook into it through debugfs
> when booting is finished.
> 
While MCE technically is a diagnostics service, do we want to start
adding dependencies on debugfs in long-running, common-place daemons? I
was under the impression we were to avoid using debugfs for anything
other than values for one-off debugging.

Cheers,

- Ben
