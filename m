Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1IVJ6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:58:07 -0400
Received: from shutemov.name ([188.40.19.243]:55269 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab1IVJ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:58:05 -0400
Date: Thu, 22 Sep 2011 12:58:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
Message-ID: <20110922095803.GA4530@shutemov.name>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
 <1316393805-3005-7-git-send-email-glommer@parallels.com>
 <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:01:46PM -0700, Greg Thelen wrote:
> On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa <glommer@parallels.com> wrote:
> > +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
> > +{
> > +       return (mem == root_mem_cgroup);
> > +}
> > +
> 
> Why are you adding a copy of mem_cgroup_is_root().  I see one already
> in v3.0.  Was it deleted in a previous patch?

mem_cgroup_is_root() moved up in the file.

-- 
 Kirill A. Shutemov
