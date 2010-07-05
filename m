Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0GEJ6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:58:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41865 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0GEJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:in-reply-to
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=OOPr9EnRN9qtoKSWqI3tOtSj1FjLgpJmWWCHoj/SnItKblALFUiH+1R/bcsRDJGvDr
         PHx9VIJkPgC+1ZA2bu9IK8vWahyf0iOU05j6PF7tMzDiQoF0h6k09Npxr17EuX6dBuSq
         AwgUi3hFqmeqhhZsW2W9eIHtF94dxZQMBXXig=
Date: Mon, 05 Jul 2010 14:27:15 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: dfeng@redhat.com
Cc: x86@kernel.org, venki@google.com, tglx@linutronix.de,
       suresh.b.siddha@intel.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
Message-ID: <4c31ac7b.J+CU0Yt+zKZ9ho1fjKvu6Z1v@tarekhel>
References: <20100507075128@tarekhel> <4C319D61.5090002@redhat.com>
 <20100507092842@tarekhel> <4C31A7A0.1020800@redhat.com>
In-Reply-To: <4C31A7A0.1020800@redhat.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng <dfeng@redhat.com> wrote:
> On 07/05/2010 05:28 PM, Ali Gholami Rudi wrote:
> > Xiaotian Feng<dfeng@redhat.com>  wrote:
> >> Could you please try following commit in -tip tree?
> >>
> >> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> >> Author: Peter Zijlstra<peterz@infradead.org>
> >> Date:   Sat May 29 15:31:43 2010 +0200
> >>
> >>       rbtree: Undo augmented trees performance damage
> >
> > Where can I get it?  I couldn't find it either in
> > Linus' or x86 repo tip.
> http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249

It does fix it.

Thanks,
Ali

