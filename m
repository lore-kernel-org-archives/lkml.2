Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0LMVXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:23:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47751 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab0LMVXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:23:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vyTxq13C18gfW1nhR/dq5V275gXjSbQ81UM+TAqLtZUc0hGSMFJsYwNGG7Gg6+5bHr
         mymNntIMJRE70w6Pf9K/DdA7W8B+efXBW8wuJMvo1MhQSxE9seqCHmCWsHKDpwki/qSJ
         18uz1TtkBF0lFohLSZQWXWDp0H7zCIaq3TIBc=
Date: Tue, 14 Dec 2010 00:22:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Brian Rogers <brian@xyzw.org>
Cc: Jeff Mahoney <jeffm@suse.com>, balbir@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: delayacct: alignment changes break iotop
Message-ID: <20101213212253.GI1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Brian Rogers <brian@xyzw.org>, Jeff Mahoney <jeffm@suse.com>,
	balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Guillaume Chazarain <guichaz@gmail.com>, akpm@linux-foundation.org
References: <20101213113745.GE1620@bicker>
 <20101213125709.GB14178@balbir.in.ibm.com>
 <4D0639B2.4060903@suse.com>
 <4D068869.7040305@xyzw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D068869.7040305@xyzw.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, but the rule is that we don't break userspace... :/

Fixing the bug in iotop was always going to be the easy part.  It's
great that they've applied a fix to git repo but it still takes a while
to get the fix out to users so they don't notice a problem.

I think we're going to need to put an ifdef IA64 then size is 8 else
size is 4.  I just started this thread because I was hoping someone
had a different ifdef to use, like maybe there are other arches which
care about the alignment and maybe there is a way to test for it.

regards,
dan carpenter

