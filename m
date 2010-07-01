Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0GAOSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab0GAOSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:18:49 -0400
Message-ID: <4C2CA3C7.1070302@redhat.com>
Date: Thu, 01 Jul 2010 17:18:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Use u64 for gfn_t in KVM
References: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 05:00 PM, Joerg Roedel wrote:
> Hi, Avi, Marcelo,
>
> these two patches currently lie on the bottom of my npt-npt patch set. They
> came out of a discussion on the mailing list about the last version of the
> npt-npt patchset. These patches are independent of the rest of the patchset, so
> I post and discuss them seperatly. The changes to make gfn_t an u64 were
> larger than I expected which is another reason for the seperate post. Please
> let me know what you think about this change.
>
>    

Looks good.

-- 
error compiling committee.c: too many arguments to function

