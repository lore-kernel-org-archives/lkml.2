Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2ADI6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:58:25 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56104 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2ADI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:58:24 -0500
Message-ID: <4F041496.5030905@linux.vnet.ibm.com>
Date: Wed, 04 Jan 2012 14:27:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode should perform update after suspend to disk
References: <jdq23r$vni$1@dough.gmane.org> <4F03ECAF.4080207@linux.vnet.ibm.com> <4F0413A6.4060704@gmail.com>
In-Reply-To: <4F0413A6.4060704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
x-cbid: 12010408-2674-0000-0000-000002D96A05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 02:23 PM, Sven Köhler wrote:

> Am 04.01.2012 07:07, schrieb Srivatsa S. Bhat:
>> Which kernel version are you using?
> 
> I was using 3.1.4 or something. However, I updated to 3.1.7 lately.
> Sorry, I should have mentioned that.
> 
>> I tried doing suspend-to-ram and suspend-to-disk on latest kernel (3.2-rc7+)
>> and I saw exactly the same messages getting emitted from the microcode
>> module in both cases. Not sure what is going wrong in your case...
> 
> I'm absolutely puzzled, cause I just tried to reproduce it again, and
> microcode was updated successfully during resume from suspend to disk. I
> apologize for the noise.
> 

Good to hear that everything is fine :-)

Regards,
Srivatsa S. Bhat

