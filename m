Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2HDFou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:44:50 -0400
Received: from mso.anu.edu.au ([150.203.89.32]:41436 "EHLO mso.anu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2HDFoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:44:46 -0400
Message-ID: <501CB6AE.3000400@mso.anu.edu.au>
Date: Sat, 04 Aug 2012 15:44:14 +1000
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
References: <20120802040242.GB25933@thinkpad-t410> <20120802103423.GA1921@kroah.com> <501A955D.6030500@mso.anu.edu.au> <20120802161209.GF32395@thinkpad-t410> <501B01ED.9080309@mso.anu.edu.au> <501B0536.6070001@mso.anu.edu.au> <20120803045312.GB2446@thinkpad-t410> <501BD1FC.9020601@mso.anu.edu.au> <20120803141421.GA8165@thinkpad-t410> <501C7C1D.5010903@mso.anu.edu.au> <20120804035844.GA31711@thinkpad-t410>
In-Reply-To: <20120804035844.GA31711@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth,

[CC'd people, sorry we exchanged a few emails with Seth outside of the 
lists, I passed him the acpi tables and here are gmux dumps]

Allright. thanks for gmux-dump. There seems to be progress, as I can see 
the gmux dumps for the nividia-selected and intel-selected are clearly 
different (I did it twice to be sure, it checks out).
The 2 dumps are at
http://maumae.net/retina/gmux-dump_intel.dat
and
http://maumae.net/retina/gmux-dump_nvidia_only.dat
I hope you'll be able to get something from these.
Francois



On 04/08/12 13:58, Seth Forshee wrote:
> On Sat, Aug 04, 2012 at 11:34:21AM +1000, Francois Rigaut wrote:
>> Seth,
>>
>> I've put the acpi table dump in http://maumae.net/retina/acpi_tables.tgz
> The ACPI stuff for the gmux looks exactly the same as for the machine
> I've got. The I/O range is still 0x700 to 0x7ff.
>
>> As far as the mem dump, I've done it but can not see any difference
>> (between case where one or the other graphic card are selected) in
>> the first 3000 bytes. Not sure I'm doing that well though. I'm just
>> dd'ing /dev/mem with
>> dd bs=1000 count=3 if=/dev/mem of=some_file
>> Am I addressing the right memory or is the switch going to be (or
>> likely to be) somewhere else?
> That's going to access sytem memory, not the I/O space for the gmux. Try
> the attached instead. It's going to output the raw binary, so if you
> want to view the output do something like
>
>   gmux-dump | xxd -g1
>
> Seth

