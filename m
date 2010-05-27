Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab0E0KNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab0E0KNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:13:14 -0400
Message-ID: <4BFE45B5.5010808@redhat.com>
Date: Thu, 27 May 2010 13:13:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: fix compiling warning
References: <4BFC8B0D.2060106@cn.fujitsu.com>
In-Reply-To: <4BFC8B0D.2060106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 05:44 AM, Xiao Guangrong wrote:
> fix:
>
> arch/x86/kvm/svm.c: In function ‘is_erratum_383’:
> arch/x86/kvm/svm.c:1459: warning: integer constant is too large for ‘long’ type
> arch/x86/kvm/svm.c: In function ‘svm_handle_mce’:
> arch/x86/kvm/svm.c:1490: warning: unused variable ‘kvm_run’
>    

Applied (partially, got the other part from Jan already), thanks.

-- 
error compiling committee.c: too many arguments to function

