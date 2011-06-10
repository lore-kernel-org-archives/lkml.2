Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1FJKKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:10:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:44130 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1FJKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:10:13 -0400
X-IronPort-AV: E=Sophos;i="4.65,345,1304294400"; 
   d="scan'208";a="6208734"
Date: Fri, 10 Jun 2011 11:10:11 +0100
From: Tim Deegan <Tim.Deegan@citrix.com>
To: Igor Mammedov <imammedo@redhat.com>
CC: <xen-devel@lists.xensource.com>, Keir Fraser <keir@xen.org>,
        Stabellini <stefano.stabellini@eu.citrix.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <Stefano@phlegethon.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Keir Fraser <keir.xen@gmail.com>, <KAMEZAWA@phlegethon.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Paul Menage <menage@google.com>,
        Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Possible shadow bug
Message-ID: <20110610101011.GH5098@whitby.uk.xensource.com>
References: <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
 <4DE8D50F.1090406@redhat.com>
 <BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>
 <4DEE26E7.2060201@redhat.com>
 <20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com>
 <4DF0801F.9050908@redhat.com>
 <alpine.DEB.2.00.1106091311530.12963@kaball-desktop>
 <20110609150133.GF5098@whitby.uk.xensource.com>
 <4DF0F90D.4010900@redhat.com>
 <20110610100139.GG5098@whitby.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20110610100139.GG5098@whitby.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11:01 +0100 on 10 Jun (1307703699), Tim Deegan wrote:
> Actually, looking at the disassembly you posted, it looks more like it
> might be an emulator bug in Xen; if Xen finds itself emulating the IMUL
> instruction and either gets the logic wrong or does the memory access
> wrong, it could cause that failure.  And one reason that Xen emulates
> instructions is if the memory operand is on a pagetable that's shadowed
> (which might be a page that was recently a pagetable). 
> 
> ISTR that even though the RHEL xen reports a 3.0.x version it has quite
> a lot of backports in it.  Does it have this patch?
> http://hg.uk.xensource.com/xen-3.1-testing.hg/rev/e8fca4c42d05

Oops, that URL doesn't work; I meant this:
http://xenbits.xen.org/xen-3.1-testing.hg/rev/e8fca4c42d05

Tim.

-- 
Tim Deegan <Tim.Deegan@citrix.com>
Principal Software Engineer, Xen Platform Team
Citrix Systems UK Ltd.  (Company #02937203, SL9 0BG)
