Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1HYRMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:12:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16598 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1HYRMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:12:22 -0400
MIME-Version: 1.0
Message-ID: <8a95a804-7ba3-416e-9ba5-8da7b9cabba5@default>
Date: Thu, 25 Aug 2011 10:11:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure
 changes
References: <20110823145755.GA23174@ca-server1.us.oracle.com
 20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020209.4E568245.01AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes

Hi Kamezawa-san --

Domo arigato for the review and feedback!

> Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?

I separated out this header patch because I thought it would
make the key swap data structure changes more visible.  Are you
saying that it is more confusing?  Or does your compiler
have a problem after only this patch is applied? (My
compiler is fine with it.)

Thanks,
Dan
