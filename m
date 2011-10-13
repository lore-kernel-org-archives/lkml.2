Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1JMAqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:46:07 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49837 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751111Ab1JMAqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:46:04 -0400
Message-ID: <4E9634C9.3020404@xenotime.net>
Date: Wed, 12 Oct 2011 17:46:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: Tree for Oct 12 (sound/soc/codecs/wm1250-ev1)
References: <20111012175425.a2e3e6e6a92265e433aeca25@canb.auug.org.au>
In-Reply-To: <20111012175425.a2e3e6e6a92265e433aeca25@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 11:54 PM, Stephen Rothwell wrote:
> Hi all,
> 
> The linux-next tree is now available from
> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> the kernel.org servers are unavailable.
> 
> It may also turn up on git.kernel.org (depending on the mirroring).  The
> patch is still absent, however.


When no GPIO kconfig options are enabled:
(not GPIOLIB, not GENERIC_GPIO):

sound/soc/codecs/wm1250-ev1.c:32:14: error: array type has incomplete element type
sound/soc/codecs/wm1250-ev1.c:126:18: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:126:18: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:126:18: error: negative width in bit-field '<anonymous>'
sound/soc/codecs/wm1250-ev1.c:134:42: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:134:42: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:134:42: error: negative width in bit-field '<anonymous>'
sound/soc/codecs/wm1250-ev1.c:155:34: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:155:34: warning: type defaults to 'int' in type name
sound/soc/codecs/wm1250-ev1.c:155:34: error: negative width in bit-field '<anonymous>'


This was on an i386 build, but that shouldn't matter.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
