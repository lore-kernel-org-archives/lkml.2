Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1IUTP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:15:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16861 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1IUTPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:15:55 -0400
MIME-Version: 1.0
Message-ID: <80a7cf89-8aae-4db6-bc2b-fa5aa44cf978@default>
Date: Wed, 21 Sep 2011 12:15:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V10 6/6] mm: frontswap/cleancache: final flush->invalidate
References: <20110915213506.GA26426@ca-server1.us.oracle.com
 20110921150420.GC541@phenom.oracle.com>
In-Reply-To: <20110921150420.GC541@phenom.oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E7A37D3.00F0:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Sent: Wednesday, September 21, 2011 9:04 AM
> To: Dan Magenheimer
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; jeremy@goop.org; hughd@google.com;
> ngupta@vflare.org; Konrad Wilk; JBeulich@novell.com; Kurt Hackel; npiggin@kernel.dk; akpm@linux-
> foundation.org; riel@redhat.com; hannes@cmpxchg.org; matthew@wil.cx; Chris Mason;
> sjenning@linux.vnet.ibm.com; kamezawa.hiroyu@jp.fujitsu.com; jackdachef@gmail.com;
> cyclonusj@gmail.com; levinsasha928@gmail.com
> Subject: Re: [PATCH V10 6/6] mm: frontswap/cleancache: final flush->invalidate
> 
> On Thu, Sep 15, 2011 at 02:35:06PM -0700, Dan Magenheimer wrote:
> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V10 6/6] mm: frontswap/cleancache: final flush->invalidate
> 
> Just call it 's/flush/invalidate/' change.
> >
> > This sixth patch of six in this frontswap series completes the renaming
> > from "flush" to "invalidate" across both tmem frontends (cleancache and
> > frontswap) and both tmem backends (Xen and zcache), as required by akpm.
> > This change is completely cosmetic.
> >
> > [v10: no change]
> 
> No need for that.. You only need to include them if you did provide some
> new content to the patch.

OK, thanks.  Fixed in v11.  Since no code changes, not reposting,
available in git tree at: 

git://oss.oracle.com/git/djm/tmem.git#frontswap-v11
