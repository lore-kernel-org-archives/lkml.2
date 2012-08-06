Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2HFWv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:51:28 -0400
Received: from mso.anu.edu.au ([150.203.89.32]:49692 "EHLO mso.anu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab2HFWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:51:25 -0400
Message-ID: <50204A4E.5040104@mso.anu.edu.au>
Date: Tue, 07 Aug 2012 08:50:54 +1000
From: Francois Rigaut <frigaut@mso.anu.edu.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        bhelgaas@google.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
References: <501A955D.6030500@mso.anu.edu.au> <20120802161209.GF32395@thinkpad-t410> <501B01ED.9080309@mso.anu.edu.au> <501B0536.6070001@mso.anu.edu.au> <20120803045312.GB2446@thinkpad-t410> <501BD1FC.9020601@mso.anu.edu.au> <20120803141421.GA8165@thinkpad-t410> <501C7C1D.5010903@mso.anu.edu.au> <20120804035844.GA31711@thinkpad-t410> <501CB6AE.3000400@mso.anu.edu.au> <20120806134933.GA28213@thinkpad-t410>
In-Reply-To: <20120806134933.GA28213@thinkpad-t410>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon 06 Aug 2012 23:49:33 EST, Seth Forshee wrote:
> On Sat, Aug 04, 2012 at 03:44:14PM +1000, Francois Rigaut wrote:
>> Seth,
>>
>> [CC'd people, sorry we exchanged a few emails with Seth outside of
>> the lists, I passed him the acpi tables and here are gmux dumps]
>>
>> Allright. thanks for gmux-dump. There seems to be progress, as I can
>> see the gmux dumps for the nividia-selected and intel-selected are
>> clearly different (I did it twice to be sure, it checks out).
>> The 2 dumps are at
>> http://maumae.net/retina/gmux-dump_intel.dat
>> and
>> http://maumae.net/retina/gmux-dump_nvidia_only.dat
>> I hope you'll be able to get something from these.
>
> It looks like you're not really getting data from the gmux in those
> dumps. The address range should be correct based on your ACPI tables. I
> have some ideas, but it won't be much longer until I can play with one
> of these machines myself so it's probably easier if I try them out then.

allright, no worries. Delivery time can be quite long for these 
machines, I waited for mine 5 long weeks.
Hope you get yours faster.
Cheers,
Francois
PS: I'm working with Daniel Vetter [intel-fgx] for a of fix the video 
mode (corrupted), another problem for the use of the i915 driver
>
> Thanks,
> Seth
