Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0LNIQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:16:33 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:37576 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0LNIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WEOykIN/NwOSGxo7Hld5wdJniNACMPTl9mFCEhyqroRwqkhwYgVEFt86+YtWe0BxS9
         ZwM33yKjAe7e2zwY9D3/vAB+pZi4fkoxlXfgp1xA5A4ZAVepwauZLNmP+Az0uFfNYsHy
         H09ZgQ+YKMpS8d/YcI2AZp3oJUtOQG1IrVjbE=
Date: Tue, 14 Dec 2010 11:16:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Brian Rogers <brian@xyzw.org>, Jeff Mahoney <jeffm@suse.com>,
        linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [patch] delayacct: fix iotop on x86_64
Message-ID: <20101214081620.GK1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Brian Rogers <brian@xyzw.org>, Jeff Mahoney <jeffm@suse.com>,
	linux-kernel@vger.kernel.org,
	Guillaume Chazarain <guichaz@gmail.com>, akpm@linux-foundation.org
References: <20101213113745.GE1620@bicker>
 <20101213125709.GB14178@balbir.in.ibm.com>
 <4D0639B2.4060903@suse.com>
 <4D068869.7040305@xyzw.org>
 <20101213212253.GI1620@bicker>
 <20101214070243.GJ1620@bicker>
 <20101214080239.GC14178@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214080239.GC14178@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:32:39PM +0530, Balbir Singh wrote:
> I would rather abstract this better and I'd be apprehensive about the
> fix if iotop was at fault to begin with, I would rather fix iotop.
> IOW, are we fixing what iotop got wrong? Isn't it easier to backport
> the correct behaviour in iotop. I understand we broke the ABI, but
> user space can still live.
> 

The iotop people are definitely at fault and we should throw salmon at
the developers next time when we see them at a conference.  But in the
end, it's not really a matter of assigning blame to things.  It's just
annoying for users if the program stops working and you have to google
to figure out why the new kernel it broke iotop.

It's simple enough to paper over the bug for now, then fix it properly
in a couple years when everyone has upgraded their user space.

regards,
dan carpenter

