Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0FRGbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:31:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab0FRGbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:31:42 -0400
Message-ID: <4C1B12AC.8060201@zytor.com>
Date: Thu, 17 Jun 2010 23:31:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       matthew@wil.cx, macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de, jeremy@goop.org, linux-pci@vger.kernel.org
Subject: Re: [BUG][PATCH 0/2 (v.3)] x86: ioremap() problem in X86_32 PAE
References: <4C1AE64C.6040609@jp.fujitsu.com>
In-Reply-To: <4C1AE64C.6040609@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 08:21 PM, Kenji Kaneshige wrote:
> Hi,
>
> Here is a updated version (v.3) of patchset to fix ioremap() related
> problem found in x86 32-bit mode. The problem is that ioremap() maps
> wrong address for the device to which phisical addres higer than
> 32-bit is assigned (ioat device in my case).
>

Will look at it first thing in the morning.

	-hpa
