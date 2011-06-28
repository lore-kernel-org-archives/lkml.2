Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1F1ATd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:19:33 -0400
Received: from mail.candelatech.com ([208.74.158.172]:59947 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1F1AS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:18:56 -0400
Message-ID: <4E091DEB.7010000@candelatech.com>
Date: Mon, 27 Jun 2011 17:18:51 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com> <4E091670.9040405@candelatech.com>
In-Reply-To: <4E091670.9040405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 04:46 PM, Ben Greear wrote:

>> Did you even compile-test this?
>
> Well yes, but obviously I'm having a bad day!
>
> Aside from the lame mistakes in my patch..is the general approach
> usable?

I was missing slab_lock() around the on_freelist() call,
that is probably why I got the printouts about object count
being off.

Fixing that and will let it cook overnight.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

