Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1LAPtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:49:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53017 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1LAPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:49:44 -0500
Message-ID: <4ED7A213.3010900@suse.cz>
Date: Thu, 01 Dec 2011 16:49:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: daniel@ffwll.ch
CC: Keith Packard <keithp@keithp.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jiri Slaby <jirislaby@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: g33: tiled output
References: <4ED79138.5060703@suse.cz> <20111201154249.GA4291@phenom.ffwll.local>
In-Reply-To: <20111201154249.GA4291@phenom.ffwll.local>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 04:42 PM, Daniel Vetter wrote:
> On Thu, Dec 01, 2011 at 03:37:44PM +0100, Jiri Slaby wrote:
>> For some time, I'm seeing a tiled output like:
>> http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile.png
>>
>> This happens sometimes when I open selected pages in firefox. Like
>> maps above.
>>
>> Currently I'm running 3.2.0-rc3-next-20111130. This started appearing
>> after I switched to desktop fx. Will anything from the debugfs help to
>> track this down? Or better to report this to freedesktop.org?
> 
> Please test the patch Chris already replied with to your first mail. It
> might fix your issue here (if it's just a fence being stolen a bit too
> early). If that does not help, I'll have to stare at the picture some more
> to decode the type of tiling/swizzling going on. Maybe different pictures
> of corruptions might help for that.

Hi, I'm already running a kernel with that patch. The artefacts are
still there though.

thanks,
-- 
js
suse labs
