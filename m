Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0FOIom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab0FOIol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:44:41 -0400
Message-ID: <4C173D76.3070504@redhat.com>
Date: Tue, 15 Jun 2010 11:44:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] Add TSC offset tracking
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-14-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-14-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> Track the last TSC offset set for each VM and ensure that the storing of
> the offset and the reading of the TSC are never preempted by taking a
> spinlock.
>
>    

Totally missing the point - tsc is per vcpu, why do we need per-vm tracking?

-- 
error compiling committee.c: too many arguments to function

