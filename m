Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1ISEsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 00:48:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1ISEsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 00:48:50 -0400
Message-ID: <4E76CA4C.2050706@cn.fujitsu.com>
Date: Mon, 19 Sep 2011 12:51:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Zhao Jin <cronozhj@gmail.com>
CC: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm, mmu: fix incorrect return of spte
References: <1316405991-14903-1-git-send-email-cronozhj@gmail.com>
In-Reply-To: <1316405991-14903-1-git-send-email-cronozhj@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-19 12:47:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-19 12:47:31,
	Serialize complete at 2011-09-19 12:47:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 12:19 PM, Zhao Jin wrote:
> __update_clear_spte_slow should return original spte while the
> current code returns low half of original spte combined with high
> half of new spte.
> 

Thanks for your fixing.

Reviewed-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
