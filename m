Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0DITmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:42:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab0DITl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:41:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Janak Desai <janak@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] check_unshare_flags: kill the bogus
	CLONE_SIGHAND/sig->count check
In-Reply-To: Oleg Nesterov's message of  Sunday, 21 March 2010 19:48:01 +0100 <20100321184801.GA29085@redhat.com>
References: <20100321184801.GA29085@redhat.com>
X-Zippy-Says: I was in a HOT TUB!  I was NORMAL!  I was ITALIAN!!  I enjoyed th'
    EARTHQUAKE!
Message-Id: <20100409194149.1A57BBCF0@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:41:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
