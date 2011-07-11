Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1GKNLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1GKNLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:11:47 -0400
Message-ID: <4E1AF689.7000601@redhat.com>
Date: Mon, 11 Jul 2011 16:11:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-5-git-send-email-glommer@redhat.com> <4E1AF64E.6070305@redhat.com>
In-Reply-To: <4E1AF64E.6070305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 04:10 PM, Avi Kivity wrote:
>
> I think Peter acked this, yes?  Please include his acks.
>

Sorry, I meant this for the kernel/sched.c bits.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

