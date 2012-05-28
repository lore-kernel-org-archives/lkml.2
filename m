Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2E1N3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:29:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2E1N3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:29:13 -0400
Message-ID: <4FC37D94.3080404@redhat.com>
Date: Mon, 28 May 2012 16:28:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com> <4FC30C40.80500@cn.fujitsu.com>
In-Reply-To: <4FC30C40.80500@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 08:25 AM, Yanfei Zhang wrote:
> 
> Dou you have any comments about this patch set?

I still have a hard time understanding why it is needed.  If the host
crashes, there is no reason to look at guest state; the host should
survive no matter what the guest does.


-- 
error compiling committee.c: too many arguments to function
