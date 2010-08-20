Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0HTIsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0HTIr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:47:57 -0400
Message-ID: <4C6E423E.5080804@redhat.com>
Date: Fri, 20 Aug 2010 16:52:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Amit Salecha <amit.salecha@qlogic.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dhananjay Phadke <dhananjay.phadke@qlogic.com>,
        Narender Kumar <narender.kumar@qlogic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC Patch] netxen: remove firmware exports
References: <20100818095908.6606.56224.sendpatchset@localhost.localdomain> <99737F4847ED0A48AECC9F4A1974A4B80F86E69208@MNEXMB2.qlogic.org>
In-Reply-To: <99737F4847ED0A48AECC9F4A1974A4B80F86E69208@MNEXMB2.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/10 17:12, Amit Salecha wrote:
>> netxen_nic driver can store firmwares on flash, and get them porperly and
>> dynamically, so the firmwares may not appear in /lib/firmware/. However, netxen_nic
>> still exports these firmwares via modinfo, this makes our script which parses
>> modinfo output fail.
>
> NX_UNIFIED_ROMIMAGE_NAME(phanfw.bin) is already submitted and we won't submit any other fw files.
>
>> -MODULE_FIRMWARE(NX_P2_MN_ROMIMAGE_NAME);
>> -MODULE_FIRMWARE(NX_P3_CT_ROMIMAGE_NAME);
>> -MODULE_FIRMWARE(NX_P3_MN_ROMIMAGE_NAME);
>
> It's not compulsory to submit firmware files which are exported (MODULE_FIRMWARE).
> I am leaving this upto David to decide about this patch.
>

Okay. David, do you want me to submit an updated patch?

Thanks!

-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
