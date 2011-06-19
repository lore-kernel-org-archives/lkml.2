Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1FSMod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 08:44:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1FSMoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 08:44:30 -0400
Message-ID: <4DFDEF2A.7050307@redhat.com>
Date: Sun, 19 Jun 2011 15:44:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm <kvm@vger.kernel.org>, Linux-kernel <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
References: <4DF97D6C.2080900@redhat.com>
In-Reply-To: <4DF97D6C.2080900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 06:50 AM, Zachary Amsden wrote:
> The 128-bit multiply in pvclock.h was missing an output constraint for 
> EDX which caused a register corruption to appear.  Thanks to Ulrich 
> for diagnosing the EDX corruption and Avi for providing this fix 
> (which now I am sending back to you Avi..)

Applied and queued, thanks.

-- 
error compiling committee.c: too many arguments to function

