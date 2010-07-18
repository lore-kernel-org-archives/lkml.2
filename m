Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0GRPHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 11:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0GRPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 11:07:45 -0400
Message-ID: <4C4318BF.50805@redhat.com>
Date: Sun, 18 Jul 2010 18:07:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/18] Implement getnsboottime kernel API
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-16-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-16-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> Add a kernel call to get the number of nanoseconds since boot.  This
> is generally useful enough to make it a generic call.
>
>    

Please copy one of the timekeeping keepers to get their ack.

-- 
error compiling committee.c: too many arguments to function

