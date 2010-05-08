Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0EHAu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:50:58 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:59976 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0EHAu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:50:57 -0400
X-Authority-Analysis: v=1.1 cv=NIOYnwefqCV/MKW0EFJDPpcpEuWwVTNQGA0aDJzefgU= c=1 sm=0 a=jbQAF9jGaHUA:10 a=IkcTkHD0fZMA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:17 a=eNNjnCXZqFQuOcZJndQA:9 a=O8RnmSKagjWgZsE2I7l_Jx1As0UA:4 a=QEXdDO2ut3YA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.121.210.183
Subject: Re: unified page and buffer cache?
From: Phillip Susi <psusi@cfl.rr.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100507183000.GD17259@parisc-linux.org>
References: <4BCC7C05.8000803@cfl.rr.com> <4BE417CB.7000806@cfl.rr.com>
	 <20100507135329.GA17259@parisc-linux.org> <4BE4359E.9020400@cfl.rr.com>
	 <20100507183000.GD17259@parisc-linux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 20:50:53 -0400
Message-ID: <1273279853.2444.3.camel@faldara>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 12:30 -0600, Matthew Wilcox wrote:
> That would be possible, but would waste memory space.  But we've all
> got gigabytes of ram these days, maybe nobody cares.

Why would it waste memory space?  Either way it's in some memory mapping
somewhere.  It's just a matter of what file it is associated with?  The
inode of the directory, or the underlying block device?



