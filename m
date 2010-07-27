Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0G0ChA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 22:37:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46929 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab0G0Cg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 22:36:58 -0400
Subject: Re: [PATCH 4/8] v3 Allow memory_block to span multiple memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
In-Reply-To: <4C4A5985.6000206@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <4C451E1C.8070907@austin.ibm.com> <1279653481.9785.4.camel@nimitz>
	 <4C4A5985.6000206@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 26 Jul 2010 19:36:52 -0700
Message-ID: <1280198212.16922.422.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 22:09 -0500, Nathan Fontenot wrote:
> If we add a lock should I submit it as part of this patchset? or
> submit it
> as a follow-on?

It should probably be at the beginning of the patch set.  We don't want
to have a case where your set introduces races that we _need_ a later
patch to fix.

-- Dave

