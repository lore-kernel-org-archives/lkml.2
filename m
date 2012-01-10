Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2AJSNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:13:11 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42966 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932625Ab2AJSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:13:10 -0500
Message-ID: <4F0C8D58.6020003@xenotime.net>
Date: Tue, 10 Jan 2012 11:11:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
        JBeulich@suse.com, annie.li@oracle.com, waldi@debian.org,
        dgdegra@tycho.nsa.gov, david.vrabel@citrix.com, julia@diku.dk,
        tony.luck@intel.com, maxim.uvarov@oracle.com, anil@recoil.org,
        dkiper@net-space.pl, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.3 patches for 3.3-rc0
References: <20120109172549.GA31352@phenom.dumpdata.com> <CA+55aFxbnPstMx9Bajcq8cen7vpY_yOoGE86GG_Fu_ZUpL2zXg@mail.gmail.com>
In-Reply-To: <CA+55aFxbnPstMx9Bajcq8cen7vpY_yOoGE86GG_Fu_ZUpL2zXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 10:08 AM, Linus Torvalds wrote:
> On Mon, Jan 9, 2012 at 9:25 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>>  46 files changed, 2499 insertions(+), 1251 deletions(-)
> 
> Please, you too also start using -M (and --summary) for the diffstat output.

This is even included in Documentation/SubmittingPatches (not that anyone reads
documentation ;).


> It should look like this:
> 
>   44 files changed, 1513 insertions(+), 265 deletions(-)
>   create mode 100644 Documentation/ABI/stable/sysfs-bus-xen-backend
>   create mode 100644 Documentation/ABI/stable/sysfs-devices-system-xen_memory
>   rename drivers/xen/{xenfs => }/privcmd.c (92%)
>   create mode 100644 drivers/xen/privcmd.h
>   create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.c
>   rename drivers/xen/{xenfs/xenbus.c => xenbus/xenbus_dev_frontend.c} (95%)
>   create mode 100644 include/xen/xenbus_dev.h
> 
> which is a lot more true about the *real* changes.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
