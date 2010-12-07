Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0LGJ7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:59:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab0LGJ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:59:20 -0500
Message-ID: <4CFE0573.5090805@redhat.com>
Date: Tue, 07 Dec 2010 11:59:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: SVM: Add support Flush-By-ASID feature
References: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 04:25 PM, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
>
> here is the patch-set to add support for the Flush-By-ASID feature to
> KVM on AMD. Patches 1 and 2 clean up the code a little bit and patch 3
> implements the feature itself.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

