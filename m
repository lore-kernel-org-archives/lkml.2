Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1C2QmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:42:17 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:40187 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1C2QmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:42:16 -0400
X-Greylist: delayed 868 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Mar 2011 12:42:16 EDT
Message-ID: <4D92087D.3090600@tycho.nsa.gov>
Date: Tue, 29 Mar 2011 12:27:41 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Daniel Kiper <dkiper@net-space.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] xen/balloon: Cleanups and fixes for 2.6.40
References: <20110328093128.GE13826@router-fw-old.local.net-space.pl> <1301409001.18413.11.camel@zakaz.uk.xensource.com>
In-Reply-To: <1301409001.18413.11.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:30 AM, Ian Campbell wrote:
> On Mon, 2011-03-28 at 10:31 +0100, Daniel Kiper wrote:
>> Hi,
>>
>> Full list of cleanups/fixes:
>>   - xen/balloon: Use PageHighMem() for high memory page detection,
>>   - xen/balloon: Simplify HVM integration,
>>   - xen/balloon: Clarify credit calculation,
>>   - xen/balloon: Move dec_totalhigh_pages() from __balloon_append() to balloon_append().
>>
>> Those patches applies to latest Linus' git tree
>> (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git).
>> They are required by latest memory hotplug support for Xen balloon
>> driver patch which will be sent soon.
> 
> This series looks sane to me, so:
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> CC'ing Daniel De Graaf though since he has been working on the balloon
> driver recently as well.
> 
> Ian.
> 
The series also looks fine to me.

-- 
Daniel De Graaf
National Security Agency
