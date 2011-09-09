Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1IIEfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:35:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751729Ab1IIEfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:35:45 -0400
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        bvanassche@acm.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Sep 2011 21:35:44 -0700
In-Reply-To: <20110908212041.207d61a9.akpm@linux-foundation.org>
References: <cover.1314725877.git.jbaron@redhat.com>
	 <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	 <20110908165230.a7505321.akpm@linux-foundation.org>
	 <1315534396.11939.10.camel@Joe-Laptop>
	 <20110908204200.6cf7abc2.akpm@linux-foundation.org>
	 <1315540963.11939.12.camel@Joe-Laptop>
	 <20110908212041.207d61a9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315542945.11939.14.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 21:20 -0700, Andrew Morton wrote:
> The reason the distinction matters (apart from being just wrong) is
> that sometimes we want a macro for the definition and another for the
> declaration.  DEFINE_TRACE/DECLARE_TRACE, DECLARE_LGLOCK/DEFINE_LGLOCK,
> etc.

That does not mean that these uses are not declarations
as specified by the c99 standard.  They are.

cheers, Joe

