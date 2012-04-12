Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab2DLNS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:18:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43716 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab2DLNS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:18:28 -0400
Message-ID: <4F86D5FA.5030600@gmail.com>
Date: Thu, 12 Apr 2012 21:17:46 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: Re: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com> <1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com> <alpine.LSU.2.00.1204111739060.26607@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204111739060.26607@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 08:41 AM, Hugh Dickins wrote:
> On Wed, 11 Apr 2012, Cong Wang wrote:
>
>> Cc: Oleg Nesterov<oleg@redhat.com>
>> Cc: Alexey Dobriyan<adobriyan@gmail.com>
>> Signed-off-by: Cong Wang<xiyou.wangcong@gmail.com>
>
> Whereas this one, I don't object, but I don't see it as an improvement.
>

It is not am improvement, it is a trivial patch to use IS_ERR_OR_NULL().
