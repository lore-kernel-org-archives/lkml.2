Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab0EEPOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0EEPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:14:49 -0400
Message-ID: <4BE18B62.8050308@redhat.com>
Date: Wed, 05 May 2010 18:14:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com> <1273068285-3105-5-git-send-email-joerg.roedel@amd.com> <4BE184E3.1010508@redhat.com> <20100505150406.GF14542@8bytes.org> <4BE18993.50306@redhat.com>
In-Reply-To: <4BE18993.50306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 06:06 PM, Avi Kivity wrote:
>
>> You can roughly check
>> for it using the svm cpuid bit.
>
> Doesn't it kill cross-vendor migration?
>

Oh, the fact that it's in if (nested) protects against that (at least 
until Intel implements EFER.SVME.  So the patch is good.

-- 
error compiling committee.c: too many arguments to function

