Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2IEA0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:26:17 -0400
Received: from tundra.namei.org ([65.99.196.166]:33532 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2IEA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:26:14 -0400
Date: Wed, 5 Sep 2012 10:21:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: xiaoyan.zhang@intel.com, linux-kernel@vger.kernel.org,
        joseph.cihula@intel.com, gang.wei@intel.com,
        tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
        shpedoikal@gmail.com, linux-security-module@vger.kernel.org,
        james.l.morris@oracle.com, hpa@zytor.com, linux-api@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] driver/char/tpm: declare internal symbols as static
In-Reply-To: <20120830155247.GA4574@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.02.1209051020420.7357@tundra.namei.org>
References: <1377779951-1687-1-git-send-email-xiaoyan.zhang@intel.com> <20120830155247.GA4574@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   Thanks, this looks good to me.  James, can you apply this directly to
> security-next?

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
