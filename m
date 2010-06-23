Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0FWK5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:57:49 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:33291 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab0FWK5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:57:47 -0400
Message-ID: <4C21E875.20200@blueyonder.co.uk>
Date: Wed, 23 Jun 2010 11:56:53 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: alsa-user@lists.sourceforge.net
CC: LKML Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
References: <4C20B364.9060405@blueyonder.co.uk> <20100622131102.GA18432@kroah.com> <20100622133434.GZ2698@buzzloop.caiaq.de>
In-Reply-To: <20100622133434.GZ2698@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/10 14:34, Daniel Mack wrote:
> On Tue, Jun 22, 2010 at 06:11:02AM -0700, Greg KH wrote:
>> On Tue, Jun 22, 2010 at 01:58:12PM +0100, Sid Boyce wrote:
>>> I have an application using the on-board sound card mic which should
>>> send it's data to the USB card for relay to a Sofweare Defined Radio
>>> as 2 quadrature signals digital (I/Q) for transmission.
>>> On the receiving side it can take data from the Radio at up to 192K
>>> sample rate -->  program -->  Speaker on the on-board sound card -
>>> that works fine.
>>> Transmit fails, dmesg output with 48K sample rate set is:-
>>> [509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks
>>> sample rate attribute bit, cannot set.
>>> [509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks
>>> sample rate attribute bit, cannot set.
>>
>> Looks like your device does not support this :(
>>
>> Have you asked on the alsa mailing list?
>
> Yes, please post this on the ALSA list, and also provide the full output
> of "lsusb -v" with the device connected.
>
> Thanks,
> Daniel
>
Thanks Daniel.
Bus 002 Device 007: ID 041e:3f04 Creative Technology, Ltd E-Mu 0404
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 ?
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   idVendor           0x041e Creative Technology, Ltd
   idProduct          0x3f04 E-Mu 0404
   bcdDevice            1.00
   iManufacturer           1 E-MU Systems, Inc.
   iProduct                2 E-MU 0404 | USB
   iSerial                 3 E-MU-63-3F04-07D70A11-07BA0-STATION 2
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength         1832
     bNumInterfaces          4
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                2mA
     Interface Association:
       bLength                 8
       bDescriptorType        11
       bFirstInterface         0
       bInterfaceCount         4
       bFunctionClass        255 Vendor Specific Class
       bFunctionSubClass     255 Vendor Specific Subclass
       bFunctionProtocol     255 Vendor Specific Protocol
       iFunction               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      1
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  0b 24 01 00 01 bf 00 03 01 02 03
       ** UNRECOGNIZED:  0c 24 02 01 01 01 00 04 33 00 00 00
       ** UNRECOGNIZED:  11 24 06 04 01 02 01 00 02 00 02 00 02 00 02 00 00
       ** UNRECOGNIZED:  0c 24 02 02 01 06 00 02 03 00 00 00
       ** UNRECOGNIZED:  0c 24 02 03 02 06 00 02 03 00 00 00
       ** UNRECOGNIZED:  0f 24 08 0e 03 e3 01 03 04 33 00 00 01 1f 00
       ** UNRECOGNIZED:  0e 24 04 0b 02 04 0e 04 33 00 00 00 00 00
       ** UNRECOGNIZED:  11 24 04 05 03 04 02 0e 04 33 00 00 00 00 00 00 00
       ** UNRECOGNIZED:  0f 24 08 0c 01 e3 01 05 04 33 00 00 01 07 00
       ** UNRECOGNIZED:  0f 24 08 0d 02 e3 01 0c 04 33 00 00 01 03 00
       ** UNRECOGNIZED:  0f 24 08 0f 04 e3 01 0d 04 33 00 00 01 07 00
       ** UNRECOGNIZED:  09 24 03 08 01 03 00 0f 00
       ** UNRECOGNIZED:  09 24 03 07 02 03 00 0f 00
       ** UNRECOGNIZED:  09 24 03 09 02 06 00 0f 00
       ** UNRECOGNIZED:  09 24 03 0a 01 01 00 0b 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0112  1x 274 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       2
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x008e  1x 142 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       3
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x012a  1x 298 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       4
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x009a  1x 154 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       5
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x021a  1x 538 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       6
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0112  1x 274 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       7
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x024a  1x 586 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       8
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x012a  1x 298 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       9
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 10 b1 02
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x021a  1x 538 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      10
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 ee 02
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x024a  1x 586 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      11
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0220  1x 544 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      12
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0118  1x 280 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      13
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0250  1x 592 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      14
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0130  1x 304 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      15
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0220  1x 544 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      16
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0250  1x 592 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      17
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 20
       ** UNRECOGNIZED:  0b 24 02 03 02 02 10 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x00b8  1x 184 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting      18
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 01 00 01 20
       ** UNRECOGNIZED:  0b 24 02 03 02 02 10 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x00c8  1x 200 bytes
         bInterval               4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           17
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0112  1x 274 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       2
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x008e  1x 142 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       3
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x012a  1x 298 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       4
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x009a  1x 154 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       5
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x021a  1x 538 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       6
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0112  1x 274 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       7
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x024a  1x 586 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       8
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x012a  1x 298 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       9
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 10 b1 02
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x021a  1x 538 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      10
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 02 03 18 01 00 ee 02
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x024a  1x 586 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      11
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0220  1x 544 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      12
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 44 ac 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0118  1x 280 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      13
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0250  1x 592 bytes
         bInterval               4
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      14
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 80 bb 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0130  1x 304 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      15
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 88 58 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0220  1x 544 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting      16
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      2
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 0a 00 01 00
       ** UNRECOGNIZED:  0b 24 02 01 04 03 18 01 00 77 01
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes           37
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Implicit feedback Data
         wMaxPacketSize     0x0250  1x 592 bytes
         bInterval               3
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      3
       bInterfaceProtocol      0
       iInterface              0
       ** UNRECOGNIZED:  07 24 01 00 01 25 00
       ** UNRECOGNIZED:  06 24 02 01 01 00
       ** UNRECOGNIZED:  06 24 02 02 02 00
       ** UNRECOGNIZED:  09 24 03 01 03 01 02 01 00
       ** UNRECOGNIZED:  09 24 03 02 04 01 01 01 00
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x05  EP 5 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x85  EP 5 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 ?
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0001

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

