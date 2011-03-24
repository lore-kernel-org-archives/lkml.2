Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab1CXKlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab1CXKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:41:09 -0400
Message-ID: <4D8B1FC2.8050305@redhat.com>
Date: Thu, 24 Mar 2011 12:41:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH] expose async pf through our standard mechanism
References: <1300898442-13704-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1300898442-13704-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 06:40 PM, Glauber Costa wrote:
> As Avi recently mentioned, the new standard mechanism for exposing features
> is KVM_GET_SUPPORTED_CPUID, not spanning CAPs. For some reason async pf missed that.
>
> So expose async_pf here.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

