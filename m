Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab2GDMfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2GDMfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:35:21 -0400
Message-ID: <4FF43878.3000207@redhat.com>
Date: Wed, 04 Jul 2012 14:35:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: mc@linux.vnet.ibm.com
CC: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        senwang@linux.vnet.ibm.com, zwanp@cn.ibm.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] virtio-scsi: hotplug support for virtio-scsi
References: <1341294085-17164-1-git-send-email-mc@linux.vnet.ibm.com> <4FF2DC6C.1010506@redhat.com> <20120704041124.Horde.MN5WeZir309P8-qsGUCj3vA@imap.linux.ibm.com>
In-Reply-To: <20120704041124.Horde.MN5WeZir309P8-qsGUCj3vA@imap.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 10:11, mc@linux.vnet.ibm.com ha scritto:
>>>
>>>
>>> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
>>> Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
>>
>> The SoB lines are swapped.  Otherwise looks good.  Since you have to
>> respin, please add dropped event support too, it shouldn't be hard.
> 
> What does "The SoB lines are swapped" mean? should the changelog be
> placed after SoB lines?

No, the patch sender should be the last SoB line.  Sen Wang should hence
come before you, not after.

Paolo

