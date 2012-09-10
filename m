Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2IJNwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:52:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43759 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2IJNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:52:18 -0400
Date: Mon, 10 Sep 2012 15:52:13 +0200
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC v8 PATCH 00/20] memory-hotplug: hot-remove physical memory
Message-ID: <20120910135213.GA1550@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>
 <20120831134956.fec0f681.akpm@linux-foundation.org>
 <504D467D.2080201@jp.fujitsu.com>
 <504D4A08.7090602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504D4A08.7090602@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 10, 2012 at 10:01:44AM +0800, Wen Congyang wrote:
> At 09/10/2012 09:46 AM, Yasuaki Ishimatsu Wrote:
> > Hi Wen,
> > 
> > 2012/09/01 5:49, Andrew Morton wrote:
> >> On Tue, 28 Aug 2012 18:00:07 +0800
> >> wency@cn.fujitsu.com wrote:
> >>
> >>> This patch series aims to support physical memory hot-remove.
> >>
> >> I doubt if many people have hardware which permits physical memory
> >> removal?  How would you suggest that people with regular hardware can
> >> test these chagnes?
> > 
> > How do you test the patch? As Andrew says, for hot-removing memory,
> > we need a particular hardware. I think so too. So many people may want
> > to know how to test the patch.
> > If we apply following patch to kvm guest, can we hot-remove memory on
> > kvm guest?
> > 
> > http://lists.gnu.org/archive/html/qemu-devel/2012-07/msg01389.html
> 
> Yes, if we apply this patchset, we can test hot-remove memory on kvm guest.
> But that patchset doesn't implement _PS3, so there is some restriction.

the following repos contain the patchset above, plus 2 more patches that add
PS3 support to the dimm devices in qemu/seabios:

https://github.com/vliaskov/seabios/commits/memhp-v2
https://github.com/vliaskov/qemu-kvm/commits/memhp-v2

I have not posted the PS3 patches yet in the qemu list, but will post them
soon for v3 of the memory hotplug series. If you have issues testing, let me
know.

thanks,

- Vasilis
