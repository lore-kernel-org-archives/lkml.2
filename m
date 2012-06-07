Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2FGUIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:08:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57603 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2FGUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:08:07 -0400
MIME-Version: 1.0
X-Originating-IP: [41.212.116.88]
In-Reply-To: <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
 <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
 <CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com> <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Thu, 7 Jun 2012 22:59:27 +0300
Message-ID: <CAHVUoiSP7SiWCtYPvKS_1RuAV0upWmT06iN7PR1OE6NAtToirQ@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
To: Jerome Glisse <j.glisse@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 5:25 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>
> Update your libdrm to libdrm from git should fix your issue.

Hello Jerome,

Thanks for looking into this.

I am afraid that even with the very latest libdrm (git 93a5117d), the
rendering is still broken.

What else should I try? I would revert the patch that git-bisect
fingered (your patch, git 285484e2d, Linux mainline) but there are
merge problems when I try to do that, which I have not yet looked
into. Perhaps you can see if you can help me revert that patch so that
we can see if the problem then goes away?

Thanks!

-- 
Brian Gitonga Marete
Toshnix Systems - http://toshnix.com
