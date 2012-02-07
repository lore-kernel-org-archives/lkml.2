Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2BGLih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:38:37 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:50519 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2BGLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:38:36 -0500
X-Greylist: delayed 4686 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 06:38:36 EST
Message-ID: <4F310DBC.1040501@ladisch.de>
Date: Tue, 07 Feb 2012 12:40:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
References: <20120206181622.GA28811@kroah.com> <20120207084037.GA6140@citd.de> <4F30FABF.4060409@ladisch.de> <20120207105835.GA12864@citd.de>
In-Reply-To: <20120207105835.GA12864@citd.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
> On 07.02.2012 11:19, Clemens Ladisch wrote:
>> Matthias Schniedermeyer wrote:
>>> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>>
>> Please try that kernel parameter.
>
> I don't want/need ASPM, disabled is fine with me.

In your case, it appears that sound requires ASPM.


Regards,
Clemens
