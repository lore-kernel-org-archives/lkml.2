Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2JMX7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 19:59:21 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:46794 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754278Ab2JMX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 19:59:20 -0400
Message-ID: <507A004F.4080102@xenotime.net>
Date: Sat, 13 Oct 2012 16:59:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.7-uapi-tag for v3.7-rc0
References: <20121012134529.GA1560@phenom.dumpdata.com> <CA+55aFzfmJNTtrnRsEkb6B0=eTHNGuA+jBa1METOK3ycxNsM8g@mail.gmail.com>
In-Reply-To: <CA+55aFzfmJNTtrnRsEkb6B0=eTHNGuA+jBa1METOK3ycxNsM8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 07:16 PM, Linus Torvalds wrote:

> On Fri, Oct 12, 2012 at 10:45 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>>
>> Please pull!
> 
> Btw, please use the -M switch to get renames as renames (and
> --summary). You diffstat:
> 
>>  include/uapi/xen/Kbuild    |    2 +
>>  include/uapi/xen/evtchn.h  |   88 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/xen/privcmd.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/xen/Kbuild         |    2 -
>>  include/xen/evtchn.h       |   88 ---------------------------------------
>>  include/xen/privcmd.h      |   98 --------------------------------------------
>>  6 files changed, 188 insertions(+), 188 deletions(-)
> 
> is misleading, the correct one is much simpler:
> 
>  include/{ => uapi}/xen/evtchn.h  | 0
>  include/{ => uapi}/xen/privcmd.h | 0
>  include/xen/Kbuild               | 2 --
>  4 files changed, 2 insertions(+), 2 deletions(-)
>  rename include/{ => uapi}/xen/evtchn.h (100%)
>  rename include/{ => uapi}/xen/privcmd.h (100%)


showing once again that people don't read documentation  :(

(see Documentation/SubmittingPatches)

-- 
~Randy
