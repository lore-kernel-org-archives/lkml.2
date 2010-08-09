Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0HIJFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:05:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:50080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab0HIJFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:05:38 -0400
Message-ID: <4C5FC49B.9040208@kernel.org>
Date: Mon, 09 Aug 2010 11:04:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [BISECTED] Today's Linus.git hangs during boot: can't find the
 floppy controller
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 Aug 2010 09:05:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/09/2010 10:34 AM, Heiko Carstens wrote:
>>> I see a similar problem here. The kernel will boot, but the system will
>>> not initialize (no X11). 
>>> After reverting the commit, the system starts normally and the only
>>> workqueue problem left is drm related:
>>
>> I would guess that both of you have CONFIG_HOTPLUG_CPU disabled and enabling
>> that config option will make the problem disappear.
>> From the problem description and the patch it looks like it got screwed up
>> the same way I did two years ago.
>> See commits a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635 and
>> 4403b406d4369a275d483ece6ddee0088cc0d592.

Heh, that's almost hilarious.  I'll see if this can be fixed
differently this time.

Thanks.

-- 
tejun
