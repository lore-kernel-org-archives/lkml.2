Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1BOGxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:53:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46606 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1BOGxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=G2SbKOqLLCAX5/+9oS1/v2yJrGiFc3uXzFOSBBdecK9aEwQGgAcj19/Y2cKO7gpGXg
         ng8As5fzwC2kd1gmU7P5mjxA23DxYFg029+GBVlFxFv8Q3KYmsxTJ/ol3cqAkjiYTLcD
         9VS9LDkVRXNNd0OFlUCTgMhJb/PFkzX++qDj8=
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 07:53:09 +0100
Message-ID: <AANLkTimf3SL+BpzjVK=F9y4_dGnDp6ghmMKq5k=4hs0x@mail.gmail.com>
Subject: Should asus-wmi provide a way to switch displays, and why
 video_output class is unused
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: linux acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luming Yu <luming.yu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In the ongoing effort to split eeepc-wmi, and add support for Asus WMI
capable notebooks, I found that some of them are able to control
dispay output.
Currently, asus-laptop, asus_acpi and eeepc-laptop are also all able
to do that, and they use a simple sysfs file with a bitmask to do
that.

Now, I was searching the right, generic way to do that, and I found
video_output class. The issue is that nobody, even acpi/video.ko, use
it.

So, what's the right way to do that ?

Note, that in my case, I can't know what output are available, so
anyway, using video_output would be a little tricky. But still, I'm
not really comfortable adding another cryptic sysfs file, even with
proper documentation in Docuementation/ABI/.

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
