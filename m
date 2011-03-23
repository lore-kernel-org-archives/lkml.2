Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1CWODX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:03:23 -0400
Received: from twin.jikos.cz ([89.185.236.188]:52597 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab1CWODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:03:21 -0400
Date: Wed, 23 Mar 2011 15:02:35 +0100
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: dave <dave@jikos.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, adilger <adilger@dilger.ca>
Subject: Re: ext4 deep stack with mark_page_dirty reclaim
Message-ID: <20110323140235.GF17108@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	dave <dave@jikos.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, adilger <adilger@dilger.ca>
References: <alpine.LSU.2.00.1103141156190.3220@sister.anvils>
 <20110314204627.GB8120@thunk.org>
 <FE7209AC-C66C-4482-945E-58CF5AF8FEE7@dilger.ca>
 <20110315152222.GW17108@twin.jikos.cz>
 <1300206353-sup-9759@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300206353-sup-9759@think>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 12:26:43PM -0400, Chris Mason wrote:
> Also, the ftrace stack usage tracer gives more verbose output that
> includes the size of each function.

Yet another one on the list is the -fstack-size option in new gcc 4.6 [*].
It creates a file with .su extension containing lines in format
file:line:char:function_name	stack_size	linkage_type

eg.

a.c:168:5:main     224     static


dave

* http://gcc.gnu.org/gcc-4.6/changes.html
