Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1CXJmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:42:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52447 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1CXJmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gVhvrgnWnn+VU86WR4BKAcBUyOQSNiTcvQjBGO9cgk8q1ZbrSM1SrkEnUOquEbO9Fh
         nSRKrKJzHAxbPF0jBf6OmblpCSAqW6nKCMtZAv6WDr2HpErb7TPRhIWvdqGEuUjLnPCf
         gQh5R4hJgXrvQB2A224lcbo71xXOvCNsNeWjI=
Date: Thu, 24 Mar 2011 10:42:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Subject: mutex: Separate out mutex_spin()
Message-ID: <20110324094231.GF12038@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324094119.GD12038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh... Please drop the extra "Subject: " from subject before applying.
Thanks.

-- 
tejun
