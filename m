Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1LQSaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 13:30:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1LQSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:30:01 -0500
Date: Sat, 17 Dec 2011 18:29:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
Message-ID: <20111217182955.GX2203@ZenIV.linux.org.uk>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
 <20111216192320.GA23748@infradead.org>
 <1324071040.29432.3.camel@sasha>
 <20111216233041.GU2203@ZenIV.linux.org.uk>
 <87vcpfjosl.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcpfjosl.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 07:14:26PM +0530, Aneesh Kumar K.V wrote:

> > It's a 9P bug; fix it there.  Turning random internal constants into a part
> > of ABI is not going to work.
> 
> I guess we would need to define them at the protocol level then. 
> Something like f88657ce3f9713a0c62101dffb0e972a979e77b9. 

The question is which ones make sense at the protocol level...
