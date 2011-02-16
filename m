Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab1BPELL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:11:11 -0500
Received: from core.signal11.us ([64.251.29.136]:35646 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab1BPELI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:11:08 -0500
Message-ID: <4D5B4E5D.5060101@signal11.us>
Date: Tue, 15 Feb 2011 23:11:09 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, greg@kroah.com, stern@rowland.harvard.edu,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v4 0/1] HID: Report Descriptor in Sysfs
References: <20110123225935.GB12488@kroah.com> <1295841018-8561-1-git-send-email-alan@signal11.us>
In-Reply-To: <1295841018-8561-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb 15 23:11:07 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d5b4e5b145072019838155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2011 10:50 PM, Alan Ott wrote:
> So I'd like to have access to the HID report descriptor in a sysfs entry, so
> I can read it without opening the device.  hid-core seemed like the place to
> put it.
>
> Using the /sys/class links, for hidraw devices, this puts a new file,
> report_descriptor in the directory:
> 	/sys/class/hidraw/hidraw0/device/
>
> For my USB device (for example), the new file is in:
> 	/sys/bus/usb/devices/1-5.3:1.0/0003:046D:C216.0001/
>
> For my Bluetooth device, the new file is in:
> 	/sys/class/bluetooth/hci0/hci0:11/0005:054C:0268.0002/
>
> I'm not super confident that these file locations are the best place, but I
> made a best guess so that it could be discussed.  The current location is
> where the hid-core stuff lives.  Is there a reason these directories are
> named bus:vendor:product:id (instead of hid-core or something similar)?  Is
> there a better way to do this?
>
> Alan.
>
> Alan Ott (1):
>    hid: Add HID Report Descriptor to sysfs.
>
>   Documentation/ABI/testing/sysfs-driver-hid |   10 ++++++++
>   drivers/hid/hid-core.c                     |   33 ++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-driver-hid
>
>    

I Didn't get any responses on the fixed-up patch. Does anyone have any 
issue with this?

Alan.


