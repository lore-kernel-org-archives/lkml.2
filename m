Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0IMO7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:59:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62545 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0IMO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=V+6VG+7ANnq+SjeoliSh97gTWR9YHU0yVgNSawzTtlHKGlDLEu+vbkeCu/ln5mOQC8
         UrVv6VZ2Pk3UfrSoOFbx9rveotaNyq/DZuHh+HD+f2eiFUOArFkIXH5m9+gRXGTbOQjS
         TfsPXjmG5k/IT0xv6Zo2k25j1/UgD9i4MmLL8=
Message-ID: <4C8E3C40.50808@suse.cz>
Date: Mon, 13 Sep 2010 16:59:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: phil@ipom.com, stable@kernel.org, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
References: <Pine.LNX.4.44L0.1009131045000.1584-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131045000.1584-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 04:48 PM, Alan Stern wrote:
> On Mon, 13 Sep 2010, Jiri Slaby wrote:
>> In other words, what I could do is to add some printks into
>> hub_port_connect_change if that's called at all. If you need some
>> thorough debugging printks, please send me a patch to test instead.
> 
> Hmm.  I'd prefer to explain how it's all supposed to work and let you
> figure out where best to look.  Or try to debug it myself.  Does this
> happen with other sorts of USB devices as well, or just wacom?

With some sort of devices (I cannot reproduce myself). It's unrelated to
wacom -- people with wacom were unable to even start X with this kernel.
If you look at the bugreport, there are several examples:
ID 046d:c517 Logitech, Inc. LX710 Cordless Desktop Laser defunct
Microsoft USB keyboard defunct x Logitech mice OK
046a:0021 Cherry GmbH keyboard defunct
logitech wireless laptop mouse defunct
A$Tech wireless laptop mouse defunct
TypeMatrix USB 2030 (ID : 1e54:2030) defunct

thanks,
-- 
js
suse labs
