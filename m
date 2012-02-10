Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2BJTnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:43:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:31037 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958Ab2BJTnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:43:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="106224965"
Message-ID: <4F35746A.1090109@intel.com>
Date: Fri, 10 Feb 2012 11:47:54 -0800
From: "Nelson, Doug" <doug.nelson@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com> <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com> <4F3552A4.70902@intel.com> <4F3572C1.1060703@redhat.com>
In-Reply-To: <4F3572C1.1060703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 11:40 AM, Paolo Bonzini wrote:
> On 02/10/2012 06:23 PM, Nelson, Doug wrote:
>>> # scsi devices
>>> KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*",
>>> IMPORT{program}="scsi_id --export --whitelisted -d $tempnode",
>>> ENV{ID_BUS}="scsi"
>>
>> The rule I had was not excluding partitions.   I'll fix that and try 
>> again.
>
> So was it a custom rule, or it came with the distro?
>

It's a custom rule we've been using for a long time to rename our 672 x 
ssd's.


> Paolo

