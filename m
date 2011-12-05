Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1LEKJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:09:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1LEKJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:09:04 -0500
Message-ID: <4EDC9836.2000508@redhat.com>
Date: Mon, 05 Dec 2011 11:08:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>  <1322661299-28855-2-git-send-email-pbonzini@redhat.com>  <1322867228.11728.19.camel@pasglop> <4EDA5E7F.30508@redhat.com> <1322950969.11728.24.camel@pasglop>
In-Reply-To: <1322950969.11728.24.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 11:22 PM, Benjamin Herrenschmidt wrote:
>> >  You can fix this in QEMU; READ and WRITE commands can be split in
>> >  multiple parts.  The scsi-block device I added recently does this.
> You can split -some- commands... it's clumsy and not always legit, you
> don't always know all commands (what about vendor commands such as
> firmware updates etc...)

For the record, firmware updates won't run under virt unless you make 
qemu runs with CAP_SYS_RAWIO.

Paolo
