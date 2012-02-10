Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab2BJTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:40:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52324 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2BJTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:40:52 -0500
Message-ID: <4F3572C1.1060703@redhat.com>
Date: Fri, 10 Feb 2012 20:40:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "Nelson, Doug" <doug.nelson@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com> <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com> <4F3552A4.70902@intel.com>
In-Reply-To: <4F3552A4.70902@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 06:23 PM, Nelson, Doug wrote:
>> # scsi devices
>> KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*",
>> IMPORT{program}="scsi_id --export --whitelisted -d $tempnode",
>> ENV{ID_BUS}="scsi"
>
> The rule I had was not excluding partitions.   I'll fix that and try again.

So was it a custom rule, or it came with the distro?

Paolo
