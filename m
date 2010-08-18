Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0HRNgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab0HRNgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:36:00 -0400
Message-ID: <4C6BE2BD.1030606@redhat.com>
Date: Wed, 18 Aug 2010 21:40:13 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Amit Salecha <amit.salecha@qlogic.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Phadke <dhananjay.phadke@qlogic.com>,
        Narender Kumar <narender.kumar@qlogic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ameen Rahman <ameen.rahman@qlogic.com>
Subject: Re: [RFC Patch] netxen: remove firmware exports
References: <20100818095908.6606.56224.sendpatchset@localhost.localdomain> <99737F4847ED0A48AECC9F4A1974A4B80F86E69129@MNEXMB2.qlogic.org> <4C6BDDCB.9040800@redhat.com> <99737F4847ED0A48AECC9F4A1974A4B80F86E6913F@MNEXMB2.qlogic.org>
In-Reply-To: <99737F4847ED0A48AECC9F4A1974A4B80F86E6913F@MNEXMB2.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/10 21:19, Amit Salecha wrote:
>> Then we can work with David Woodhouse and make these firmware available in /lib/firmware
>>
> Actually I was not updated, NX_UNIFIED_ROMIMAGE_NAME (phanfw.bin) is already submitted and its present in linux-firmware.git.
>

Good.

> I will get back to you on NX_P2_MN_ROMIMAGE_NAME, NX_P3_CT_ROMIMAGE_NAME and NX_P3_MN_ROMIMAGE_NAME.
> Whether this will be submitted ?
>

Ok, thanks a lot!


-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
