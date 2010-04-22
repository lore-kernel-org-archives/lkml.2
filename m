Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0DVLEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab0DVLEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:04:42 -0400
Message-ID: <4BD02D45.4030905@redhat.com>
Date: Thu, 22 Apr 2010 14:04:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/8] More fixes for nested svm
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 01:33 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> here is another set of nested svm fixes. They fix NMI code to make UP Hyper-V
> root domain booting. The patches also add better handling for nested entry
> failures and mce intercepts.
> Also in this patchset are the fixes for the supported cpuid reporting for svm
> features. These patches were taken from the nested-npt patchset and slightly
> modified. These patches are also marked for -stable backporting.
> The probably most important fix is about exception reinjection. This didn't
> work reliably before and is fixed with the patch in this series now. This fix
> also touches common x86 code but that should be ok because it could be reused
> by nested-vmx later.
> Please review and give comments (or apply ;-).
>    

Looks good.  I'll wait a day or two for more reviews (esp. Alex).

-- 
error compiling committee.c: too many arguments to function

