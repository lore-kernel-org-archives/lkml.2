Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2JVSiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab2JVSiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:38:16 -0400
Date: Mon, 22 Oct 2012 14:37:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, holzheu@linux.vnet.ibm.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20121022183755.GE3401@redhat.com>
References: <20121018141449.GB18147@redhat.com>
 <20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
 <20121019151753.GF27052@redhat.com>
 <20121022.153219.30891002.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022.153219.30891002.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:32:19PM +0900, HATAYAMA Daisuke wrote:

[..]
> BTW, I feel you basically shows positive attitude to this patch set
> itself. I believe that kdump has merits only. Could you tell me what
> is needed for this patch set to be acked by you?

I don't have any objections to bringing up more than 1 cpu in second
kernel. Somebody who needs the code better in this area needs to provide
by Reviewed-by/Acked-by though.

Thanks
Vivek
