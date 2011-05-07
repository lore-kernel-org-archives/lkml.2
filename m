Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1EGQGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:06:32 -0400
Received: from jensen.inet.no ([195.139.68.2]:8509 "HELO jensen.inet.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755712Ab1EGQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:06:30 -0400
Date: Sat, 7 May 2011 18:06:28 +0200
From: Michael Shuldman <michaels@inet.no>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        karls@inet.no, netdev <netdev@vger.kernel.org>
Subject: Re: bug in select(2) regarding non-blocking connect(2) completion?
Message-ID: <20110507160628.GA11163@jensen.inet.no>
References: <20110507105152.GA13459@jensen.inet.no>
 <1304770358.2821.1139.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304770358.2821.1139.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote,
> Well, if you missed the original error report, all next getpeername()
> and SO_ERROR will do the same, and select() says fd is ready for 'write'

Many thanks for that.  I was not aware that SO_ERROR would not get
set if the connect(2) failed "permanently" immediately, but have
now tested that it does.  The other "strangeness" might very well
be caused by bugs related to this, so apologies for the noise and
many thanks for the help.

With kind regards,

-- 
  _ // 
  \X/ -- Michael Shuldman 

