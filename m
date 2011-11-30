Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1K3VDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:03:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52243 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1K3VDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:03:20 -0500
MIME-Version: 1.0
In-Reply-To: <20110922002235.53ae8ed70b92d9d325a79a62@canb.auug.org.au>
References: <20110921155850.09c858bb38205bb2cc0c8f0a@canb.auug.org.au>
 <CAFkjPTk0JWAYSJBC4fK6DT10MxER+vuFbYNvR6=cTN=sxmZNgg@mail.gmail.com> <20110922002235.53ae8ed70b92d9d325a79a62@canb.auug.org.au>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Wed, 30 Nov 2011 15:02:58 -0600
Message-ID: <CAFkjPTmDk2BmF8U52Te=YojJsFCcz2bJPJG8X0mZFjqAho9TyQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 21
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 9:22 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eric,
>
> On Wed, 21 Sep 2011 09:10:31 -0500 Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>
>> You can switch the v9fs tree to pull from the for-next branch of
>> github.com:ericvh/linux.git until kernel.org gets back.  Hopefully
>> that will resolve the reported merge conflict.
>
> OK, I will switch to this tree from tomorrow - assuming that the real
> Eric does't complain :-).
>

v9fs tree for-next branch is back on kernel.org:
git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-next

Thanks,
    -eric
