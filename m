Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2CGDbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:31:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33729 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2CGDbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120306123959.1921bcca.akpm@linux-foundation.org>
References: <1331045377.17099.2.camel@deneb.redhat.com>
	<1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120306123959.1921bcca.akpm@linux-foundation.org>
Date: Wed, 7 Mar 2012 09:01:15 +0530
Message-ID: <CAAHN_R1uTxVAKTTR53nMgGP=3_yXNYF_BSEcjzKv40fruRinnA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix task_nommu build regression in linux-next
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Salter <msalter@redhat.com>, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 2:09 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  7 Mar 2012 01:46:33 +0530
> Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:
>
>> Commit b7b2a0afacada237005068294cb0ccc49d32889e resulted in a build
>> failure for nommu builds:
>
> Bare git commit IDs aren't very useful, because the ID of a patch can
> be different in different trees.  And in linux-next, the ID of a patch
> can change over time.  This is why we like to refer to commits using the
> formulation b7b2a0afacad ("procfs: mark thread stack correctly in
> proc/<pid>/maps").

Thanks, I'll keep this in mind.


-- 
Siddhesh Poyarekar
http://siddhesh.in
