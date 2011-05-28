Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1E1LY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:24:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38141 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1E1LY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:24:27 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        tytso <tytso@mit.edu>
Subject: Re: [PATCH 2/4] EXT4: Set NOSEC flag early when there are no xattrs
In-reply-to: <4DE0BB71.9000303@gmail.com>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org> <1306536845-24162-2-git-send-email-andi@firstfloor.org> <4DE0BB71.9000303@gmail.com>
Date: Sat, 28 May 2011 07:24:08 -0400
Message-Id: <1306581836-sup-9169@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4DE0DB64.00CA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Marco Stornelli's message of 2011-05-28 05:08:01 -0400:
> Il 28/05/2011 00:54, Andi Kleen ha scritto:
> > From: Andi Kleen<ak@linux.intel.com>
> >
> > This avoids a xattr lookup on every write.
> >
> > Cc: tytso@mit.edu
> > Signed-off-by: Andi Kleen<ak@linux.intel.com>
> 
> Are ext2/3 affected too? It seems to me that more or less the xattr 
> management for the extN series is the same, isn't it?

Yes, everyone who uses mbcache.

-chris
