Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2D0Fbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:31:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52895 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2D0Fbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:31:46 -0400
Subject: RE: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "S, Sreeram" <Sreeram.S@netapp.com>
Cc: Ravishankar <cyberax82@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@mit.edu>
In-Reply-To: <402249329CEF3E49AACD14423D8386EE03C6B5E5@SACEXCMBX03-PRD.hq.netapp.com>
References: <402249329CEF3E49AACD14423D8386EE03C6B35C@SACEXCMBX03-PRD.hq.netapp.com>
	 <CAO_LctSkkqctOEaC_CPDB7yHCzgAYe+G3rPQBFT3jh1-cCT22A@mail.gmail.com>
	 <402249329CEF3E49AACD14423D8386EE03C6B5E5@SACEXCMBX03-PRD.hq.netapp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 07:31:41 +0200
Message-ID: <1335504701.2775.67.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 05:25 +0000, S, Sreeram wrote:
> Thanks a lot Ravi for the response.
> 
> But, the IP header is 40 bytes and so I think I should expect all
> those 40 bytes to be returned to my program when I enable this option.
> Isnt that correct ?
> 
> Here, TTL and TOS are getting returned because I have explicitly
> enabled the returns of IP_RECVTTL and IP_RECVTOS to my program using
> setsockopt. Otherwise even they wouldn’t have been returned.
> 
> I still think that the kernel is not returning what it should return
> when I enable IP_RECVOPTS. Please correct me if you think I am wrong.
> 
>  
> 
> Also, what are the other ways of getting the IP header other than RAW
> sockets, if the current approach does not work?
> 
>  

IP options are not IP header.

Try to send an IP packets with options, and your program will work.




