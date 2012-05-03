Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2ECW35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab2ECW34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:29:56 -0400
Date: Thu, 3 May 2012 18:29:49 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4-rc4 oom killer out of control.
Message-ID: <20120503222949.GA13762@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120426193551.GA24968@redhat.com>
 <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1205031513400.1631@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205031513400.1631@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:14:09PM -0700, David Rientjes wrote:

 > Dave, did you get a chance to test this out?  It's something we'll want in 
 > the oom killer so if I can add your Tested-by it would be great.  Thanks!

Yes, this seems to be an improvement in my case (the fuzzer got killed every time
rather than arbitary system processes).

Feel free to add my Tested-by:

thanks,

	Dave
