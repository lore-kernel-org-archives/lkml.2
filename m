Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1HBM0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:26:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:62881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1HBM0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:26:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,306,1309762800"; 
   d="scan'208";a="34234393"
Date: Tue, 2 Aug 2011 20:26:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110802122617.GA14694@localhost>
References: <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801112330.GA27190@infradead.org>
 <20110801165242.GA18802@infradead.org>
 <20110802114428.GA6014@localhost>
 <20110802120445.GF12870@dastard>
 <20110802121601.GA13061@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802121601.GA13061@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And the interesting thing is, that test case always fails in one box
> and succeed in another.

Ah it's my fault. The failure is caused by some debug aids I added to
the tools.. Sorry for the noises.
