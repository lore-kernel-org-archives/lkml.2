Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0IPOBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0IPOBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:01:48 -0400
Message-ID: <4C922347.1040607@redhat.com>
Date: Thu, 16 Sep 2010 16:01:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: MMU: Don't track nested fault info in error-code
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com> <1284479173-4515-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1284479173-4515-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/14/2010 05:46 PM, Joerg Roedel wrote:
> This patch moves the detection whether a page-fault was
> nested or not out of the error code and moves it into a
> separate variable in the fault struct.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

