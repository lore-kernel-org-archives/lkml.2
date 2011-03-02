Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1CBJmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:42:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:50940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab1CBJmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:42:47 -0500
Date: Wed, 2 Mar 2011 10:42:46 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jan Kara <jack@suse.cz>,
        "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110302094246.GA7496@quack.suse.cz>
References: <20110126081529.GA28909@sli10-conroe.sh.intel.com>
 <1297502512.29573.26.camel@debian>
 <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
 <1297650318.29573.2482.camel@debian>
 <1297732201.24560.2.camel@sli10-conroe>
 <20110221164909.GG6584@quack.suse.cz>
 <1298449487.14712.1064.camel@debian>
 <20110224121339.GE23042@quack.suse.cz>
 <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
 <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-03-11 14:56:43, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > On Thu, Feb 24, 2011 at 1:13 PM, Jan Kara <jack@suse.cz> wrote:
> >> On Wed 23-02-11 16:24:47, Alex,Shi wrote:
> >>> Though these patches can not totally recovered the problem, but they are
> >>> quite helpful with ccache enabled situation. It increase 10% performance
> >>> on 38-rc1 kernel.
> >>  OK and what was the original performance drop with WRITE_SYNC change?
> >>
> >>> I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here:
> >>> with patches:
> >>  I'm attaching patches rebased on top of latest Linus's tree.
> >> Corrado, could you possibly run your fsync-heavy tests so that we see
> >> whether there isn't negative impact of my patches on your fsync-heavy
> >> workload? Thanks.
> > The workload was actually Jeff's, and the stalls that my change tried
> > to mitigate showed up on his enterprise class storage. Adding him so
> > he can test it.
> 
> Sorry for the late reply.  You can use either fs_mark or iozone to
> generate an fsync-heavy workload.  The test I did was to mix this with a
> sequential reader.  If you can point me at patches, I should be able to
> test this.
  The latest version of patches is attached to:
https://lkml.org/lkml/2011/2/24/125

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
