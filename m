Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1LPRmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:42:16 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38076 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752011Ab1LPRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:42:05 -0500
Message-ID: <4EEB9105.3030100@xenotime.net>
Date: Fri, 16 Dec 2011 10:42:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 9 (ibmphp)
References: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au> <d4bdd33396b823c5241c4939b981e8a6.squirrel@xenotime.net> <4EE637F3.7070606@xenotime.net> <CAErSpo5dbAJiJ4FhR4bso+4MnJ9mk45T2Z+spmdzRr95w8jAZg@mail.gmail.com>
In-Reply-To: <CAErSpo5dbAJiJ4FhR4bso+4MnJ9mk45T2Z+spmdzRr95w8jAZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 04:41 PM, Bjorn Helgaas wrote:
> On Mon, Dec 12, 2011 at 10:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 12/09/2011 10:51 AM, Randy Dunlap wrote:
>>>
>>> On Thu, December 8, 2011 9:32 pm, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20111208:
>>>
>>> (This build error  was first seen in 20111208.)
>>>
>>>
>>> ERROR: "pci_scan_bus" [drivers/pci/hotplug/ibmphp.ko] undefined!
>>>
>>> Full randconfig file is attached.
>>
>>
>> Same for 20111212.
> 
> I changed pci_scan_bus() from an inline function (visible to modules)
> to a normal function (by default, not visible to modules), which broke
> the ibmphp.ko build.
> 
> The updated patch is attached, as well as the incremental change (just
> adding "EXPORT_SYMBOL(pci_scan_bus);".

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

(although those git sha hashes in the filenames did confuse 'patch';
maybe I need a newer version of patch)

> (Also available at git://github.com/bjorn-helgaas/linux.git on the "pci-scan-v6"
> branch as bef4a9eefaa69dd9bc998e29d619127d1653683d)
> 
> Bjorn


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
