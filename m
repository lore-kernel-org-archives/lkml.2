Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab2KOX25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:28:57 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:47220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2KOX2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:28:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>, Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [Patch v5 0/7] acpi,memory-hotplug: implement framework for hot removing memory
Date: Fri, 16 Nov 2012 00:33:17 +0100
Message-ID: <5603900.8uSmar4juL@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1637174.XPDXHMEQY8@vostro.rjw.lan>
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com> <alpine.DEB.2.00.1211151450040.27188@chino.kir.corp.google.com> <1637174.XPDXHMEQY8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 12:22:58 AM Rafael J. Wysocki wrote:
> On Thursday, November 15, 2012 02:51:52 PM David Rientjes wrote:
> > On Thu, 15 Nov 2012, Wen Congyang wrote:
> > 
> > > Note:
> > > 1. The following commit in pm tree can be dropped now(The other two patches
> > >    are already dropped):
> > >    54c4c7db6cb94d7d1217df6d7fca6847c61744ab
> > > 2. This patchset requires the following patch(It is in pm tree now)
> > >    https://lkml.org/lkml/2012/11/1/225
> > > 
> > 
> > So this is based on the acpi-general branch of 
> > git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git correct?
> 
> It should be based on that, yes.
> 
> > And the branch's HEAD commit 54c4c7db6cb9 ("ACPI / memory-hotplug: call 
> > acpi_bus_trim() to remove memory device") can be reverted before this 
> > series is applied?
> 
> Why?

Ah, because of patch [2/7].  I wonder what tree this one is supposed to
apply to.  Surely not to linux-pm.git/acpi-general.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
