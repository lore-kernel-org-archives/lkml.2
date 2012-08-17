Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab2HQWab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:30:31 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:53885 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757934Ab2HQWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:30:28 -0400
Message-ID: <502EC5A6.7040502@xenotime.net>
Date: Fri, 17 Aug 2012 15:28:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Justin M. Forbes" <jforbes@redhat.com>
CC: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.5.x boot hang after conflicting fb hw usage <driver> vs VESA
 VGA - removing generic driver
References: <1345242330.3841.8.camel@fedora64.linuxtx.org>
In-Reply-To: <1345242330.3841.8.camel@fedora64.linuxtx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 03:25 PM, Justin M. Forbes wrote:

> for <driver>, we have verified cases on inteldrmfb, radeondrmfb, and
> cirrusdrmfb.
> 
> This is the last message displayed before the system hangs.  This seems
> to be hitting a large number of users in Fedora, though certainly not
> everyone.  This started happening with the 3.5 updates, and is still an
> issue.  It appears to be a race condition, because various things have
> allowed boot to continue for some users, though there is no clear work
> around. Has anyone else run across this?  Any ideas.  For more
> background we have the following bugs:
> 
> inteldrmfb:
> https://bugzilla.redhat.com/show_bug.cgi?id=843826
> 
> radeondrmfb:
> https://bugzilla.redhat.com/show_bug.cgi?id=845745
> 
> cirrusdrmfb <kvm>:
> https://bugzilla.redhat.com/show_bug.cgi?id=843860
> 
> It should be noted that the conflicting fb hw usage message is not new,
> it has been around for a while, but this is the last message seen before
> the hang.


Hi,  (adding dri-devel mailing list)


I started seeing this problem on 3.5-rc6.

AFAICT, the system is not actually hung, it's just that no output
is showing up on the real (physical) output device (display) -- it's
going somewhere else (or to the bit bucket).

-- 
~Randy
