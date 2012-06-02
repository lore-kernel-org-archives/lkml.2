Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab2FBRrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 13:47:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58272 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343Ab2FBRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 13:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120602174134.GA13626@redhat.com>
References: <1338656062-25008-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120602174134.GA13626@redhat.com>
Date: Sat, 2 Jun 2012 23:17:35 +0530
Message-ID: <CAAHN_R0zbTc5xCfxyU9VM+V8VRjSRR073ar1bstQuChcgRFf3w@mail.gmail.com>
Subject: Re: [PATCH] Avoid dereferencing a possibly NULL mm
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2012 23:11, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes, this looks wrong, but the task without ->mm shouldn't have
> ->clear_child_tid != NULL, so this is harmless.
>

Oh right, I overlooked that. Thanks.


-- 
Siddhesh Poyarekar
http://siddhesh.in
