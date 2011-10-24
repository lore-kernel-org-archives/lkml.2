Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1JXHmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:42:05 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:51015 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751703Ab1JXHmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:42:03 -0400
X-QQ-mid: esmtp4t1319442054t400t19916
X-QQ-SSF: 000000000000000020K000000000000
Message-ID: <4EA516C6.1010706@qq.com>
Date: Mon, 24 Oct 2011 15:41:58 +0800
From: Xiao Guangrong <xiao.guangrong@qq.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Zhao Jin <cronozhj@gmail.com>
CC: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: initialize sptes early
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
In-Reply-To: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/10/24 15:21, Zhao Jin wrote:
> Otherwise, the following kvm_sync_pages() will see invalid sptes in a new
> shadow page.
> 

No, kvm_sync_pages just handle the unsync page, but the new sp is the sync page.
