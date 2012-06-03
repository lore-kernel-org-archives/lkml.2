Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2FCRrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 13:47:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47018 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752872Ab2FCRra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 13:47:30 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19FsNtIz8hFTO12xJw2toFarnfXojrjU45Tlk448D
	6pg9VjGskB+0C9
Message-ID: <4FCBA31A.2060901@gmx.net>
Date: Sun, 03 Jun 2012 19:47:06 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: lenb@kernel.org, len.brown@intel.com
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-thinkpad@linux-thinkpad.org
Subject: Re: [PATCH V2 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <4F85ED86.8010002@gmx.net> <CAErSpo7ynK9wWBRTfXSSSp3JtThs7_eTttKVfsHMJbKh7JSK1Q@mail.gmail.com>
In-Reply-To: <CAErSpo7ynK9wWBRTfXSSSp3JtThs7_eTttKVfsHMJbKh7JSK1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/12 18:42, Bjorn Helgaas wrote:

> On Wed, Apr 11, 2012 at 2:45 PM, Witold Szczeponik
> <Witold.Szczeponik@gmx.net>  wrote:
>> Hello everybody,
>>
>> this simple patch series continues the work begun in commit
>> 18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates
>> with empty/disabled resources are handled.
> 
> For all three patches:
> 
> Reviewed-by: Bjorn Helgaas<bhelgaas@google.com>
> 

Hi Len, 

I noticed that none of the patches made it into 3.5-rc1.  These patches are important to support some (vintage) IBM ThinkPads, hence my interest in getting them included in the kernel.  But they are also of general value and should not introduce any regressions. 

If there is anything I still need to do, like providing better documentation, etc., just let me know. 

NB: I am sending this mail to both the ...@intel.com and ...@kernel.org addresses, for I received mails from you from either account.  I apologize for any inconvenience caused by this. 


Thanks.  --- Witold
