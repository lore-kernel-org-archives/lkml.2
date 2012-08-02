Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2HBWzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:55:18 -0400
Received: from mso.anu.edu.au ([150.203.89.32]:46904 "EHLO mso.anu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2HBWzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:55:14 -0400
Message-ID: <501B0536.6070001@mso.anu.edu.au>
Date: Fri, 03 Aug 2012 08:54:46 +1000
From: Francois Rigaut <frigaut@mso.anu.edu.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
References: <1343407934-459-1-git-send-email-mjg@redhat.com> <20120731223240.GD19134@kroah.com> <20120801165400.GA3042@srcf.ucam.org> <20120801232147.GA6228@kroah.com> <20120802040242.GB25933@thinkpad-t410> <20120802103423.GA1921@kroah.com> <501A955D.6030500@mso.anu.edu.au> <20120802161209.GF32395@thinkpad-t410> <501B01ED.9080309@mso.anu.edu.au>
In-Reply-To: <501B01ED.9080309@mso.anu.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth,

I have put the osx system.log, which is the only file where I can see 
mux and AGC related message, at http://maumae.net/retina/system.log
Thanks,
Francois

On 03/08/12 08:40, Francois Rigaut wrote:
> Hi Seth,
>
> Sorry for the belated response. On Oz time here.
> I don't have a /var/log/kernel.log !
> Let me make sure of something:
> This switcher code is to be run on osx, no? That's where gfxcardstatus 
> lives and where I can effect the card switch. Just to make sure.
> So I'm running osx mountain lion, and the only thing I see in the logs 
> when I switch cards (using gfxcardstatus) is what I pasted below. and 
> you're right, it was not in message.log, but system.log (it was late). 
> I just went through the whole thing again.
> Am I missing something?
> Cheers,
> Francois
>
> On 03/08/12 02:12, Seth Forshee wrote:
>> On Fri, Aug 03, 2012 at 12:57:33AM +1000, Francois Rigaut wrote:
>>> Greg, Seth,
>>>
>>> Here is what the message.log shows:
>>>
>>> switching to the HD4000 (integrated):
>>>
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x42803c0
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: 
>>> CGXMuxAcknowledge: Posting glitchless acknowledge
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: 
>>> MPAccessSurfaceForDisplayDevice: Set up page flip mode on display 
>>> 0x042803c0 device: 0x10c678320  isBackBuffered: 0 numComp: 1 numDisp: 3
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x42803c0
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003d
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003e
>>> Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003f
>>>
>>> switching to the nvidia (discrete):
>>>
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x42803c0
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003d
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003e
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x3f003f
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: 
>>> CGXMuxAcknowledge: Posting glitchless acknowledge
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: 
>>> MPAccessSurfaceForDisplayDevice: Set up page flip mode on display 
>>> 0x042803c0 device: 0x10c678320  isBackBuffered: 0 numComp: 1 numDisp: 3
>>> Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received 
>>> display connect changed for display 0x42803c0
>>>
>>> Hope that helps.
>> Thanks for trying it out, but it's not really what I was hoping for. I
>> get a bunch of messages similar to these in /var/log/kernel.log, mixed
>> in with a lot of other stuff.
>>
>>   AGC:: setMuxRegister:1666 (728, 1, 1)
>>   AGC:: setMuxRegister:1666 (710, 1, 4)
>>   AGC:: getMuxRegister:1647 (716, 1) = 1
>>
>> I don't even have message.log. You don't have a kernel.log? Do you see
>> any messages like those if you run dmesg?
>>
>> Seth

