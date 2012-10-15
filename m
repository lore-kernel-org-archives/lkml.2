Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2JOVku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2JOVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:40:49 -0400
Date: Mon, 15 Oct 2012 14:40:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, criu@openvz.org,
        ebiederm@xmission.com, rientjes@google.com, gorcunov@openvz.org,
        devel@openvz.org
Subject: Re: [PATCH] proc: check vma->vm_file before dereferencing
Message-Id: <20121015144048.8fa16d28.akpm@linux-foundation.org>
In-Reply-To: <20121015152957.24859.7960.stgit@localhost.localdomain>
References: <20121015152957.24859.7960.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 19:30:03 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> It can be equal to NULL.
> 

Please write better changelogs, so people do not have to ask questions
such as:

- Under what conditions does this bug trigger?

- In which kernel version(s)?

- Is it a post-3.6 regression?

Thanks.

