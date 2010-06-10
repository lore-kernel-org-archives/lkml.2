Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab0FJOR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991Ab0FJORZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:17:25 -0400
Message-ID: <4C10F3C7.8080503@redhat.com>
Date: Thu, 10 Jun 2010 17:16:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kvm@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [11/23] KVM: Fix KVM_SET_SIGNAL_MASK
References: <20100610110.764742110@firstfloor.org> <20100610111047.1ED28B1A2B@basil.firstfloor.org>
In-Reply-To: <20100610111047.1ED28B1A2B@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 02:10 PM, Andi Kleen wrote:
> Real bug fix.
>
> When the user passed in a NULL mask pass this on from the ioctl
> handler.
>
> Found by gcc 4.6's new warnings.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

