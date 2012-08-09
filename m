Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2HILzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:55:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36472 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2HILzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120809114901.GV12174@arwen.pp.htv.fi>
References: <1343135720-26559-1-git-send-email-aletes.xgr@gmail.com>
	<20120809114242.GA4689@breakpoint.cc>
	<20120809114901.GV12174@arwen.pp.htv.fi>
Date: Thu, 9 Aug 2012 08:55:11 -0300
Message-ID: <CAAAP30EgLx70N7JDSQ2DPB_sFEkiTGhUDmBUkrrem07=Pd+KoA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: gadget: composite: parse dt values
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: balbi@ti.com
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 8:49 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Aug 09, 2012 at 01:42:42PM +0200, Sebastian Andrzej Siewior wrote:
>> On Tue, Jul 24, 2012 at 10:15:20AM -0300, Alexandre Pereira da Silva wrote:
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/usb/gadget.txt
>> > @@ -0,0 +1,20 @@
>> > +Usb Gadget DeviceTree bindings
>> > +
>> > +These optional properties inside the usb device controller node are used to
>> > +change some of the gadget drivers configuration:
>> > +- vendor-id: Usb vendor id
>> > +- product-id: Usb product id
>> > +- release: Version of this device
>> > +- vendor: Textual description of the vendor
>> > +- device: Textual description of this device
>> > +- serial: Textual representation of the device's serial number
>> > +
>> > +Binding Example:
>> > +   usbd@31020000 {
>> > +           vendor-id = <0x0525>;
>> > +           product-id = <0xa4a6>;
>> > +           release = <1>;
>> > +           vendor = "Some Corp";
>> > +           device = "Test Device";
>> > +           serial = "12345";
>
> on top of everything Sebastian said, I think we should stick to the
> field names set forth on the USB specification meaning that instead of
> vendor-id we should use idVendor, instead of vendor we should use
> iManufacturer, and so on.

Thanks for the feedback.

I agree that this should look more like the usb specifications and
allow mapping between usb interfaces and gadget drivers.

I will rework this to provide a new patch that at least don't conflict
with this idea.
