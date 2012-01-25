Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2AYSfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:35:21 -0500
Received: from shutemov.name ([176.9.204.213]:40878 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2AYSfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:35:19 -0500
Date: Wed, 25 Jan 2012 20:35:57 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] cgroups: add res_counter_write_u64() API
Message-ID: <20120125183557.GA28834@shutemov.name>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
 <1326478441-3048-4-git-send-email-fweisbec@gmail.com>
 <20120116122713.GA25863@shutemov.name>
 <20120125183100.GD20878@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120125183100.GD20878@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 07:31:03PM +0100, Frederic Weisbecker wrote:
> On Mon, Jan 16, 2012 at 02:27:13PM +0200, Kirill A. Shutemov wrote:
> > On Fri, Jan 13, 2012 at 07:13:47PM +0100, Frederic Weisbecker wrote:
> > > Extend the resource counter API with a mirror of res_counter_read_u64() to
> > > make it handy to update a resource counter value from a cgroup subsystem
> > > u64 value file.
> > 
> > I still think it worth to have two versions of res_counter_write_u64().
> > From my POV, it's clean enough, but consistent with res_counter_read_u64()
> > and faster on 64bit system.
> > 
> > What do you think?
> 
> Yeah right let's do this. Can I get your signed-off-by to take the below?

Yes.

-- 
 Kirill A. Shutemov
