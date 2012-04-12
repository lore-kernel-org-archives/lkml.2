Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908Ab2DLSrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:47:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60853 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931Ab2DLSrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:47:02 -0400
Message-ID: <4F872322.8040909@gmail.com>
Date: Thu, 12 Apr 2012 14:46:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com> <1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com> <CACVxJT_o-mR5u2XgDbECDM-SSR18j+wDY8pd7=Jb+FGCz4SSTQ@mail.gmail.com>
In-Reply-To: <CACVxJT_o-mR5u2XgDbECDM-SSR18j+wDY8pd7=Jb+FGCz4SSTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/12/12 9:23 AM), Alexey Dobriyan wrote:
> On Wed, Apr 11, 2012 at 8:59 AM, Cong Wang<xiyou.wangcong@gmail.com>  wrote:
>> -       if (mm&&  !IS_ERR(mm)) {
>> +       if (!IS_ERR_OR_NULL(mm)) {
>
> I personally find original code way more readable.

personally, me too. but new one is also acceptable to me.

thanks.

