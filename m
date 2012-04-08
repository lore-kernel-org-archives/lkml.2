Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2DHRk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:40:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41227 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2DHRky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:40:54 -0400
MIME-Version: 1.0
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
Date: Sun, 8 Apr 2012 19:40:52 +0200
Message-ID: <CAFLxGvwyx6S6+eZtR=UNSQe_O+W7oZW=GosseL54HGpjtYGXjg@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 0/43] Completing the user namespace
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 7:10 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> - Capabilities are localized to the current user namespace making
>  it safe to give the initial user in a user namespace all capabilities.
>

So, this makes LXC and friends ready for hostile environments?
IOW a root user (with all capabilities) sitting in his own namespace can no
longer ham the host?

-- 
Thanks,
//richard
