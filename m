Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1CAT4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:56:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1CAT4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:56:52 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jan Kara <jack@suse.cz>, "Alex\,Shi" <alex.shi@intel.com>,
        "Li\, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso\@mit.edu" <tytso@mit.edu>,
        "jaxboe\@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen\, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
References: <1295402148.4773.143.camel@debian>
	<1295402606.1949.871.camel@sli10-conroe>
	<20110120151656.GC18875@redhat.com>
	<20110126081529.GA28909@sli10-conroe.sh.intel.com>
	<1297502512.29573.26.camel@debian>
	<AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
	<1297650318.29573.2482.camel@debian>
	<1297732201.24560.2.camel@sli10-conroe>
	<20110221164909.GG6584@quack.suse.cz>
	<1298449487.14712.1064.camel@debian>
	<20110224121339.GE23042@quack.suse.cz>
	<AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 Mar 2011 14:56:43 -0500
In-Reply-To: <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
	(Corrado Zoccolo's message of "Sat, 26 Feb 2011 15:45:12 +0100")
Message-ID: <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Thu, Feb 24, 2011 at 1:13 PM, Jan Kara <jack@suse.cz> wrote:
>> On Wed 23-02-11 16:24:47, Alex,Shi wrote:
>>> Though these patches can not totally recovered the problem, but they are
>>> quite helpful with ccache enabled situation. It increase 10% performance
>>> on 38-rc1 kernel.
>>  OK and what was the original performance drop with WRITE_SYNC change?
>>
>>> I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here:
>>> with patches:
>>  I'm attaching patches rebased on top of latest Linus's tree.
>> Corrado, could you possibly run your fsync-heavy tests so that we see
>> whether there isn't negative impact of my patches on your fsync-heavy
>> workload? Thanks.
> The workload was actually Jeff's, and the stalls that my change tried
> to mitigate showed up on his enterprise class storage. Adding him so
> he can test it.

Sorry for the late reply.  You can use either fs_mark or iozone to
generate an fsync-heavy workload.  The test I did was to mix this with a
sequential reader.  If you can point me at patches, I should be able to
test this.

Cheers,
Jeff
