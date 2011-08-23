Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1HWNzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1HWNzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:55:02 -0400
Date: Tue, 23 Aug 2011 09:54:53 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] various fixes v3
Message-ID: <20110823135452.GA2526@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <20110823013224.GA7190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823013224.GA7190@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 06:32:24PM -0700, Greg KH wrote:
> On Thu, Aug 11, 2011 at 02:36:17PM -0400, Jason Baron wrote:
> > Hi,
> > 
> > Dynamic debug fixes and cleanups. Only changes from v2 are a re-base against
> > Linus's latest tree and the inclusion of the re-posted version for patch #11.
> 
> I applied the first 8, as it seemed like there was lots of discussion
> about #9.
> 
> Care to send the rest when you all have those worked out?
> 

Hi Greg,

The comments on #9 were mostly around formatting. The 'take #2' version
is fine: https://lkml.org/lkml/2011/8/15/395. Do you need me to re-post
it? If not please also take 10, 11.

Thanks,

-Jason

