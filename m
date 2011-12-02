Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1LBDPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 22:15:55 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49645 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1LBDPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 22:15:54 -0500
Message-ID: <4ED84314.5070107@oss.ntt.co.jp>
Date: Fri, 02 Dec 2011 12:16:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com> <4ED826CA.5030502@oss.ntt.co.jp>
In-Reply-To: <4ED826CA.5030502@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/02 10:15), Takuya Yoshikawa wrote:
> (2011/12/02 4:42), Sasha Levin wrote:
>> It's enough for memory slot to be readable, as the comment above the check
>> states.
>>
>> A user should be able to create read-only memory slot.

Note: at that time, it looked to me that the API did not allow me to know
which type was being registered.

Do you want to create read only memory slots for kvm tool?

	Takuya

> 
> I submitted the original patch like you to speed up page table walking,
> a hot path in KVM, and Avi applied the patch with changing the VERIFY_READ
> to VERIFY_WRITE:  on x86, both do the same check.  You can see that on the
> commit.
> 
> After that, Xiao started to write with __xxx_user() based on this check IIRC.
> So you should keep the code as is and change the comment if you like!
> 
> Thanks,
> 	Takuya
> 
