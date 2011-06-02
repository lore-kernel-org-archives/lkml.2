Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab1FBHmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:42:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59638 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab1FBHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=xcd2GtNsjkLGMDfhfFf2n24eOmvKDSXpmF/K1pSP2OjrWi30p+OHTkjWh2iK12ldTL
         NIbpLoH21X3zriFAgPxc6XJPT0n9ciUSL6BgT2r2oKJGw/lAjAnTOzufRPg1L7l3le9w
         B7YIp3F7zWIzV/VxFHHaw06ryo+h+lnj/NO5c=
MIME-Version: 1.0
In-Reply-To: <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Thu, 2 Jun 2011 09:42:01 +0200
Message-ID: <BANLkTika_yHtvYdyG0CANGT6mvADruH8KQ@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: "Ted Ts'o" <tytso@mit.edu>, "D. Jansen" <d.g.jansen@googlemail.com>,
        david@lang.hm, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
> The real fix is that applications need to be fixed to be less
> write-happy.

So do you agree to export barriers to user space? Because as you said
yourself, that would be the only way for apps to avoid fsync without
losing data safety. And since you want the problem fixed with the
apps, we need to provide them with the means to do so, right?
