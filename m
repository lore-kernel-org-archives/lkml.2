Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1CPFqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:46:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52771 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1CPFqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:46:38 -0400
Message-ID: <4D804EBD.4030904@us.ibm.com>
Date: Tue, 15 Mar 2011 22:46:37 -0700
From: Sridhar Samudrala <sri@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: No iproute2 for 2.6.38
References: <20110315195534.0cc43032@nehalam>
In-Reply-To: <20110315195534.0cc43032@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2011 7:55 PM, Stephen Hemminger wrote:
> I am not going to bother releasing for 2.6.38 the only changes
> were later reverted.
2.6.38 includes support for macvlan/macvtap 'passthru' mode that allows 
assigning
SR-IOV VFs to a KVM guest via macvtap/virtio.
It is not possible to support live migration using direct assignment of 
VF's to a guest,
but 'passthu' assignment makes this possible.

Enabling this feature requires the following patch to iproute2 that 
allows creating macvlan
device in 'passthru' mode.
     http://patchwork.ozlabs.org/patch/69515/
Looks like this patch is still marked as 'Awaiting upstream'.

Could you apply this patch and it would be great if a version of 
iproute2 is released for 2.6.38.

Thanks
Sridhar

> ---
> Roopa Prabhu (1):
>        iproute2: add VF_PORT support
>
> Stephen Hemminger (3):
>        Update to lasest kernel headers
>        Revert "iproute2: add VF_PORT support"
>        v2.6.38
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


