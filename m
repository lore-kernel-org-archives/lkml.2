Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0DVLKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0DVLKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:10:35 -0400
Message-ID: <4BD02EA5.4060500@redhat.com>
Date: Thu, 22 Apr 2010 14:10:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm vmx: free vpid when fail to create vcpu
References: <4BC9744B.1050107@cn.fujitsu.com>
In-Reply-To: <4BC9744B.1050107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 11:41 AM, Lai Jiangshan wrote:
> Fix bug of the exception path, free allocated vpid when fail
> to create vcpu.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

