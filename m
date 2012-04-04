Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2DDRZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:25:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24870 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab2DDRZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:25:47 -0400
MIME-Version: 1.0
Message-ID: <331d4603-ac1e-40a5-b581-c18becf3ae9a@default>
Date: Wed, 4 Apr 2012 10:25:33 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: Frontswap feedback from LSF/MM and patches
References: <4F7C7DA6.8000406@linux.vnet.ibm.com>
In-Reply-To: <4F7C7DA6.8000406@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F7C8414.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Frontswap feedback from LSF/MM and patches
> 
> Dan,
> 
> I know you presented at LSF/MM.  I was wondering if you'd could
> give a quick summary of any feedback you received regarding frontswap,
> for those of us that were not there.

Hi Seth (and all) --

The feedback on frontswap was much more encouraging this
time, but the bottom line was re-post them and people would
take another look.

Andrea was much more supportive with writethrough as an
option because he believes it will greatly improve the
stability and usability for zcache in a KVM host.  He
was also pleased with a zcache policy change for clean
pages, but that doesn't (directly) affect frontswap.

Rik was much more supportive, and akpm said he would
take another look.  I didn't get a chance to talk to
James Bottomley as to whether he was satisfied with
the latest zcache benchmarking (the lack of which was
the core of his frontswap objections).

I think the MM community is now starting to understand
how all the transcendent memory parts fit together,
that the sum of the parts has some good value and
potential, and that frontswap is a critical piece
in the tmem ecosystem.

But we'll see when it is re-posted.... ;-)

> Konard,
> 
> Can you post the latest frontswap patches to the list since the
> last post was v10 back in Sept 2011
> (https://lkml.org/lkml/2011/9/15/367) and those patches no longer
> apply cleanly.  I know you have them in your git repo, but
> I think they need to be on the list too.

While I agree a re-post is necessary, Konrad has ensured
the most recent frontswap is in linux-next so, by definition,
applies cleanly to 3.4-rc1.

Konrad, I'd like to add a small change to optionally enable
writethrough (and am traveling so won't get to that until next
week).  I also think we should seriously consider rolling
in the module support changes from Erlangen University before
posting another frontswap version to lkml/linux-mm.

But, yes, I am much more encouraged that frontswap will
have a good chance of being merged for the next window (3.5),
so let's ensure we get it re-posted soon to incorporate
community feedback in plenty of time before the next window.

Whether zcache should be promoted for the same window or should
wait another cycle is a decision I will leave to Konrad and
Greg and/or any other affected maintainers.

Dan
