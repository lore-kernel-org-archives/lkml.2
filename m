Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1FOQRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:17:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45164 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1FOQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PhVI+jqEUbDLnXbSmOjBdt3GY1SK6Ih34sm9YHYafCFERA4uozsuwUACg1L089BmAV
         Ob0rr7VTRhrCeQ9DwFflyn/tKChdZ9GXWWYZPtyzrnFW29Zw6gQrb9amEPvkEU/DJpR9
         1qUfql08g1UTioDE5Dum2qICihFc0lqENItBE=
Message-ID: <4DF8DB09.40103@gmail.com>
Date: Wed, 15 Jun 2011 18:17:13 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device plugged into xhci port not detected after a resume
References: <4DF85A1F.1080001@gmail.com> <20110615153816.GC10160@kroah.com>
In-Reply-To: <20110615153816.GC10160@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-11 17:38, Greg KH schreef:
> On Wed, Jun 15, 2011 at 09:07:11AM +0200, Maarten Lankhorst wrote:
>> I plugged a simple usb mouse in xhci that isn't found after a resume.
> What kernel version are you using?
>
3.0rc3
