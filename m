Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2LTFea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:34:30 -0500
Received: from www.maurer-it.com ([213.129.239.114]:47869 "EHLO
	proxmox.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2LTFeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:34:25 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 00:34:25 EST
From: Dietmar Maurer <dietmar@proxmox.com>
To: Luiz Capitulino <lcapitulino@redhat.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Michal Hocko <mhocko@suse.cz>, "aquini@redhat.com" <aquini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        John Stultz <john.stultz@linaro.org>, Mel Gorman <mgorman@suse.de>,
        "agl@us.ibm.com" <agl@us.ibm.com>,
        "amit.shah@redhat.com" <amit.shah@redhat.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [Qemu-devel] [RFC 3/3] virtio-balloon: add auto-ballooning
	support
Thread-Topic: [Qemu-devel] [RFC 3/3] virtio-balloon: add auto-ballooning
	support
Thread-Index: AQHN3aewsF1keFIa8EWPaRBQL7q7SZgf7HeAgAE8ILA=
Date: Thu, 20 Dec 2012 05:24:12 +0000
Message-ID: <24E144B8C0207547AD09C467A8259F75578B8BD8@lisa.maurer-it.com>
References: <1355861815-2607-1-git-send-email-lcapitulino@redhat.com>
	<1355861815-2607-4-git-send-email-lcapitulino@redhat.com>
	<20121218225330.GA28297@lizard.mcd00620.sjc.wayport.net>
 <20121219093039.51831f6f@doriath.home>
In-Reply-To: <20121219093039.51831f6f@doriath.home>
Accept-Language: en-US, de-AT
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Wow, you're fast! And I'm glad that it works for you, so we have two
> > full-featured mempressure cgroup users already.
> 
> Thanks, although I think we need more testing to be sure this does what we
> want. I mean, the basic mechanics does work, but my testing has been very
> light so far.

Is it possible to assign different weights for different VMs, something like the vmware 'shares' setting?

