Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1IRUni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 16:43:38 -0400
Received: from shutemov.name ([188.40.19.243]:41531 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab1IRUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 16:43:36 -0400
Date: Sun, 18 Sep 2011 23:43:35 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 1/7] Basic kernel memory functionality for the Memory
 Controller
Message-ID: <20110918204335.GB28611@shutemov.name>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-2-git-send-email-glommer@parallels.com>
 <20110917174535.GA1658@shutemov.name>
 <4E7567E0.9010401@parallels.com>
 <20110918190509.GC28057@shutemov.name>
 <4E764259.5070209@parallels.com>
 <20110918203931.GA28611@shutemov.name>
 <4E76572B.2000904@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E76572B.2000904@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 05:40:11PM -0300, Glauber Costa wrote:
> On 09/18/2011 05:39 PM, Kirill A. Shutemov wrote:
> > On Sun, Sep 18, 2011 at 04:11:21PM -0300, Glauber Costa wrote:
> >> On 09/18/2011 04:05 PM, Kirill A. Shutemov wrote:
> >>> On Sun, Sep 18, 2011 at 12:39:12AM -0300, Glauber Costa wrote:
> >>>>> Always zero in root cgroup?
> >>>>
> >>>> Yes, if we're not accounting, it should be zero. WARN_ON, maybe?
> >>>
> >>> -ENOSYS?
> >>>
> >> I'd personally prefer WARN_ON. It is good symmetry from userspace PoV to
> >> always be able to get a value out of it. Also, it something goes wrong
> >> and it is not zero for some reason, this will help us find it.
> >
> > What's the point to get non-relevant value?
> > What about -ENOSYS + WARN_ON?
> >
> Well,
> 
> what about not even registering kernel memory files for !root cgroup?

ENOENT works for me ;)

-- 
 Kirill A. Shutemov
