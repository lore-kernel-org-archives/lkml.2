Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1BVIic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:38:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1BVIib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:38:31 -0500
Message-ID: <4D637621.1000109@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:38:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, avi@redhat.com
CC: mtosatti@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: Enable async page fault processing.
References: <1296559307-14637-1-git-send-email-gleb@redhat.com> <1296559307-14637-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1296559307-14637-3-git-send-email-gleb@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:37:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:37:24,
	Serialize complete at 2011-02-22 16:37:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/-9/-28163 03:59 AM, Gleb Natapov wrote:
> If asynchronous hva_to_pfn() is requested call GUP with FOLL_NOWAIT to
> avoid sleeping on IO. Check for hwpoison is done at the same time,
> otherwise check_user_page_hwpoison() will call GUP again and will put
> vcpu to sleep.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
