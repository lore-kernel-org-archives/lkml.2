Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0IIDOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:14:03 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:45163 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0IIDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:13:59 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (suspend tree related)
From: Bojan Smojver <bojan@rexursive.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100909125838.6c82edc4.sfr@canb.auug.org.au>
References: <20100909125838.6c82edc4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 13:13:56 +1000
Message-ID: <1284002036.2614.39.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 12:58 +1000, Stephen Rothwell wrote:
> Caused by commit 2b2609c19ff19361360552786bd252ef40dfe5ce ("PM /
> Hibernate: Compress hibernation image with LZO").
> 
> See Rule 1 in Documentation/SubmitChecklist.  There is a missing
> include of linux/vmalloc.h. 

Thanks. I see I succeeded - first patch broke the build - yay! ;-)

Rafael,

Can you please add vmalloc.h to the thingy. I don't have commit access,
obviously.

-- 
Bojan

