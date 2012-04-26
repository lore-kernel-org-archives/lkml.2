Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2DZOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2DZOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:06:57 -0400
Date: Thu, 26 Apr 2012 10:06:53 -0400
From: Dave Jones <davej@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel BUG at include/net/netns/generic.h:41
Message-ID: <20120426140653.GA2111@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>,
	"Myklebust, Trond" <Trond.Myklebust@netapp.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20120328002346.GB3077@redhat.com>
 <20120402172600.GA3728@redhat.com>
 <1333390230.13718.34.camel@lade.trondhjem.org>
 <4F7DC37F.7090404@parallels.com>
 <20120405161241.GA23658@redhat.com>
 <4F7DC4CC.9080502@parallels.com>
 <20120425225855.GA5537@redhat.com>
 <4F98EA72.6010300@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F98EA72.6010300@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:25:54AM +0400, Stanislav Kinsbursky wrote:
 
 > >   >  >
 > >   >  >    >   2) how often do you experience this problem? Not every boot, I suppose?
 > >   >  >    >   3) And is it easy for you to reproduce?
 > >   >  >
 > >   >  >  It happens most the time, but not every time.
 > >   >
 > >   >  Ok, I'll send the patch soon.
 > >   >  Hope, it will help.
 > >
 > > I didn't see a follow-up patch on this, and I'm still seeing the BUG in rc4.
 > >
 > Dave, search for "SUNRPC: register PipeFS file system after pernet 
 > sybsystem" in your mail.
 > You are in CC list.

ah, missed that somehow.
I see it's now in Linus' tree too,

Thanks,

	Dave
