Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2JRN6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:58:02 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37561 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2JRN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <507FA2B3.3080403@redhat.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAM_iQpVVCjJ0Bde9RS9Rm-0RJ=CtTyX3eUH45+oaaepvdAvAmQ@mail.gmail.com>
	<20120923202727.GA28937@mwanda>
	<CAE9FiQX-R1L-0LDZNTbk-a6SUog+=tTrdwcfr0QUczH_PLMMpw@mail.gmail.com>
	<20120929071318.GA7444@gmail.com>
	<CABqxG0czidut37LkwqH2_D44ng-HWHudjgZr9w8csqnGVUT0rA@mail.gmail.com>
	<507FA2B3.3080403@redhat.com>
Date: Thu, 18 Oct 2012 21:57:59 +0800
Message-ID: <CAM_iQpVWS81jCu=P53auFiDvGeZsW-ONRqEF2=K2SK-vrT4VhQ@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dave Young <dyoung@redhat.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Flavio Leitner <fbl@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 2:33 PM, Dave Young <dyoung@redhat.com> wrote:
> Here is a patch for the reverting:
> ---
> x86 mm: Revert find_early_table_space fix
>
> 722bc6b16771ed80871e1fd81c86d3627dda2ac8 Try to address the issue that the
> first 2/4M should use 4k pages if PSE enabled. but extra counts should only
> valid for x86_32. This commit cause kdump regression, kdump kernel hangs happens
> with it.
>
> As Yinghai Lu said they should be reverted. see below post:
> https://lkml.org/lkml/2012/9/4/533
>
> As there's a later fix to above fix which is bd2753b2dda7bb43c7468826de75f49c6a7e8965
> So we need revert both of these two commits.
>
> Tested kdump on physical and virutual machines.

Looks good to me,

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks for the fix!
