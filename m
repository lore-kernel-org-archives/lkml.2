Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1B0MQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 07:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1B0MQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 07:16:34 -0500
Message-ID: <4D6A409E.9010107@redhat.com>
Date: Sun, 27 Feb 2011 14:16:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] expose kvmclock upper msr set.
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1298483054-1665-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 07:44 PM, Glauber Costa wrote:
> We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> for a while now, but we're not exposing it yet, meaning nobody is using it.
> This simple patch takes care of that.

We're exposing them via KVM_GET_SUPPORTED_CPUID, leaf KVM_CPUID_FEATURES.

-- 
error compiling committee.c: too many arguments to function

