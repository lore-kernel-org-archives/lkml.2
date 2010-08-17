Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0HQPsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:48:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:60218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0HQPs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:48:29 -0400
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and
 the implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Salman Qazi <sqazi@google.com>, paulmck@us.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adurbin@google.com
In-Reply-To: <20100817152352.GA10785@amd>
References: <1281957914.1926.1249.camel@laptop>
	 <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
	 <20100817152352.GA10785@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Aug 2010 17:48:14 +0200
Message-ID: <1282060094.1926.3038.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 01:23 +1000, Nick Piggin wrote:
> How about something like this?

Ah, very nice indeed. Looks like it will indeed close the hole.

Thanks Nick!
