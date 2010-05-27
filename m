Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab0E0MNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:13:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab0E0MNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:13:41 -0400
Message-ID: <4BFE61EF.3080102@redhat.com>
Date: Thu, 27 May 2010 15:13:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
References: <20100527145307.0e6d537c.sfr@canb.auug.org.au> <20100527101957.GT3266@amd.com>
In-Reply-To: <20100527101957.GT3266@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 01:19 PM, Roedel, Joerg wrote:
> On Thu, May 27, 2010 at 12:53:07AM -0400, Stephen Rothwell wrote:
>    
>> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
>> produced this warning:
>>
>> arch/x86/kvm/svm.c: In function 'svm_handle_mce':
>> arch/x86/kvm/svm.c:1489: warning: unused variable 'kvm_run'
>>
>> Introduced by commit 5c91e7b615f7b6b36f6ad32356bb786bed5b7764 ("KVM: SVM:
>> Implement workaround for Erratum 383").
>>      
> Fix for that is already posted and should be in the KVM tree soon.
>
>    

I've just pushed it to linux-next.

-- 
error compiling committee.c: too many arguments to function

