Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab1K3RUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:20:12 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47350 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755565Ab1K3RUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:20:08 -0500
Message-ID: <4ED67387.90902@xenotime.net>
Date: Wed, 30 Nov 2011 10:18:47 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?S=E9rgio_Basto?= <sergio@serjux.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: linux-next: Tree for Nov 29 (drm)
References: <20111129152040.3040fe9780886ee0e066a131@canb.auug.org.au>	 <4ED5417C.1030908@xenotime.net> <1322673417.31541.1.camel@segulix>
In-Reply-To: <1322673417.31541.1.camel@segulix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 09:16 AM, Sérgio Basto wrote:
> Randy, not dri-devel@lists.sourceforge.net, anymore 
> now is dri-devel@lists.freedesktop.org

Argh, thanks.
That was thunderbird trying to be too helpful. :(


> On Tue, 2011-11-29 at 12:33 -0800, Randy Dunlap wrote: 
>> On 11/28/2011 08:20 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20111128:
>>>
>>> The drm tree lost its build failure but gained another for which I
>>> applied a patch.
>>
>>
>> ERROR: "drm_helper_get_fb_bpp_depth" [drivers/gpu/drm/vmwgfx/vmwgfx.ko] undefined!
>>
>> Full x86_64 randconfig file is attached.
>>
>> ------------------------------------------------------------------------------
>> -- _______________________________________________ Dri-devel mailing list Dri-devel@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/dri-devel
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
