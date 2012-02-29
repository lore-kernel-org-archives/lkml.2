Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030436Ab2B2Snq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:43:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966115Ab2B2Sno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:43:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.60.26.8 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120229175327.GA20565@ubuntu-macmini>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com> <20120229175327.GA20565@ubuntu-macmini>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Feb 2012 12:43:23 -0600
X-Google-Sender-Auth: VLR6n462xwOzoJImKH7lwnVkfY8
Message-ID: <CACxGe6uc+LZjuMLS5DZELzAsHsnhObL6mdPzdMnNVbfriTfNwg@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
To: Grant Likely <grant.likely@secretlab.ca>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:53 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Feb 29, 2012 at 11:46:39AM -0600, Grant Likely wrote:
>> On Wed, Feb 22, 2012 at 8:37 AM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > Apple laptops with hybrid graphics have a device named gmux that
>> > controls the muxing of the LVDS panel between the GPUs as well as screen
>> > brightness. This driver adds support for the gmux device. Only backlight
>> > control is supported initially.
>> >
>> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>>
>> Works for me.
>>
>> Tested-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Now I just need to figure out how to get the desktop backlight widget
>> to use gmux_backlight instead of acpi_video0...
>
> The easy way is to pass acpi_backlight=vendor to the kernel, then you
> won't have acpi_vidoe0.

That did it, thanks.  I'm assume something is in the works to set it
up automatically?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
