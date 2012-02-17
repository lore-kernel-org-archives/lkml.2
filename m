Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2BQPzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:55:50 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2BQPzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:55:49 -0500
Message-ID: <4F3E787D.4020103@nod.at>
Date: Fri, 17 Feb 2012 16:55:41 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Jeff Dike <jdike@addtoit.com>, Danny Kukawka <dkukawka@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] UML net: set addr_assign_type if random_ether_addr()
 used
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de> <1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.02.2012 16:43, Danny Kukawka wrote:
> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
>
> Return state from setup_etheraddr() about returning a random
> MAC address or not and check this state in eth_configure().
>
> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>

Acked-by: Richard Weinberger <richard@nod.at>

Do you want me to pick up this patch or is it supposed to go though the 
net tree?

Thanks,
//richard
