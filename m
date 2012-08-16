Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2HPVaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:30:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:51491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab2HPVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,781,1336374000"; 
   d="scan'208";a="135135930"
Message-ID: <502D666A.9080906@linux.intel.com>
Date: Thu, 16 Aug 2012 14:30:18 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tomas Racek <tracek@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: x86, nops settings result in kernel crash
References: <20120816134834.GA11974@x1.osrc.amd.com> <1898701172.1847948.1345142715802.JavaMail.root@redhat.com> <20120816195324.5356cba0@pyramind.ukuu.org.uk>
In-Reply-To: <20120816195324.5356cba0@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 11:53 AM, Alan Cox wrote:
>>
>> Yes, if I remove the break statement (introduced by this commit), it works fine.
> 
> What version of qemu is this - do we have qemu bug here I wonder.
> 

Also, is it 32 or 64 bits?

	-hpa



