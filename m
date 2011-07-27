Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1G0JME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:12:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1G0JMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:12:01 -0400
Message-ID: <4E2FD65C.9000402@redhat.com>
Date: Wed, 27 Jul 2011 12:11:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/11] KVM: MMU: remove the mismatch shadow page
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA58B.1030503@cn.fujitsu.com>
In-Reply-To: <4E2EA58B.1030503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:31 PM, Xiao Guangrong wrote:
> If the shadow page has different cpu mode with current vcpu, we do better
> remove them since the OS does not changes cpu mode frequently
>

This is true, but is it really needed?  Won't such pages be torn down 
very quickly anyway, and will never be reestablished?

-- 
error compiling committee.c: too many arguments to function

