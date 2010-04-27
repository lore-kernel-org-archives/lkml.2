Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0D0NDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab0D0NDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:03:51 -0400
Message-ID: <4BD6E0B4.2020200@redhat.com>
Date: Tue, 27 Apr 2010 16:03:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/22] Nested Paging support for Nested SVM v2
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> Hi,
>
> this is the second and reworked version of my nested paging for nested svm
> patchset. Changes to the previous version include:
>
> 	* Renamed mmu.tdp_enabled to mmu.direct_map
> 	* Introduced two helper functions to read physical memory
> 	  locations of the current running guest level
> 	* Fixed a couple of bugs were KVM needs to read l2
> 	  physical memory and others
>
> This patchset is tested with KVM and Windows 7 XPmode. I also tested in KVM
> with Linux and Windows 7 as l2 guests. I also tested different pagesize
> combinations and did a stress tests for a couple of hours. All these tests
> showed no introduced regressions.
> Please review this second version of the patch-set. I appreciate your feedback.
>    

Ok, apart from the overflow on i386 nasties this look really good!  I 
look forward to merging v3.

-- 
error compiling committee.c: too many arguments to function

