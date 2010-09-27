Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab0I0QtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:49:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48357 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab0I0QtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ja10OID2Z7CqMiLwgLwl7k/YucrRhaxNFBluNr+UdgEL9zD5Q9JokC7bp+1wewN8O/
         7ohHipSBMP+j3k1eviiUb72WrRoAttaJzXPYdObYTLPNMtNQjBYrWeRcGN/s+XoUG4aK
         Fa5VejlzUrDzNvmuj/vAnUjabjhBjKf8yk9gw=
Message-ID: <4CA0CB0F.3060303@gmail.com>
Date: Mon, 27 Sep 2010 09:49:19 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>  <20100927151005.GC11086@tuxdriver.com> <1285603383.1732.106.camel@Joe-Laptop>
In-Reply-To: <1285603383.1732.106.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 09:03 AM, Joe Perches wrote:
> On Mon, 2010-09-27 at 11:10 -0400, John W. Linville wrote:
>> On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
>>> Below is an updated patch from the original fixing broken web addresses in the kernel.
>>> Thanks for all the help and info on this to everybody..
>>> Hopefully I didnt miss any of them(if so let me know, and I'll resend).
>> Changing a URL for a relocated page is one thing, but removing links
>> isn't necessarily a great idea.  Even if the site is technically
>> gone, it may be possible to find information e.g through the Internet
>> Archive Wayback Machine.
>
> Perhaps it'd be better to scrape the contents of the various
> web pages, collect them somewhere like wiki.kernel.org and
> encourage others to put new contributions in that site.
>
>
>
>


yeah I think somebody was saying something about having a separate file, 
with all the web addresses in them or something...In any case, up to you 
guys..

Justin P. Mattock
