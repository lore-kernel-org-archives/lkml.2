Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2A0NO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 08:14:59 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55202 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2A0NO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 08:14:57 -0500
Message-ID: <4F22A343.8030608@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 18:44:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: MCE: convert static array of pointers to per-cpu variables
References: <20120116224028.GA5072@suse.de> <20120117083843.GC13181@elte.hu> <20120117155125.GB13778@suse.de> <20120118093138.GC5842@elte.hu> <20120118144250.GA16288@suse.de> <20120119122811.GC3936@elte.hu> <20120126234914.GA13031@suse.de>
In-Reply-To: <20120126234914.GA13031@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012704-3568-0000-0000-00000120924A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 05:19 AM, Greg KH wrote:

> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> When I previously fixed up the mce_device code, I used a static array of
> the pointers.  It was (rightfully) pointed out to me that I should be
> using the per_cpu code instead.
> 
> This patch converts the code over to that structure, moving the variable
> back into the per_cpu area, like it used to be for 3.2 and earlier.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

