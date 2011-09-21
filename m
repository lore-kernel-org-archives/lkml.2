Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1IUTON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:14:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1IUTOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:14:11 -0400
MIME-Version: 1.0
Message-ID: <af23974b-20e8-47fc-8063-e7c1440e46aa@default>
Date: Wed, 21 Sep 2011 12:13:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap
 feedback
References: <20110915213446.GA26406@ca-server1.us.oracle.com
 20110921150232.GB541@phenom.oracle.com>
In-Reply-To: <20110921150232.GB541@phenom.oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E7A376B.000A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Wilk
> 
> On Thu, Sep 15, 2011 at 02:34:46PM -0700, Dan Magenheimer wrote:
> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap feedback
> 
> That is a pretty bad title. Think about it - in a year, you are going to
> try to track down something using 'git annotate' and this git commit is going
> to come up. And you look at it and this is the title. It does not carry
> the technical details of what is in the patch.
> 
> Also in case you are thinking "But there are so more git commits" - don't
> fret about them. It is OK to have many of them. So don't by shy with them.

OK, thanks for the feedback.  Since there are no code changes,
I won't flood the list with another version with the patches divided
differently (and thanks for your help reorganizing them and your offlist
review so I know it meets your approval!); instead I will just make a
new v11 git branch.  Since kernel.org is still down, if anyone
wants to look at the latest, it can be found at:

git://oss.oracle.com/git/djm/tmem.git#frontswap-v11

I'll also be asking Stephen Rothwell to pull v11 into linux-next
because the frontswap version that is there is getting a bit stale.

Hopefully everything is finally now ready for merging for the
3.2 window!

Thanks,
Dan
