Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab1DZH7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:59:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39616 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab1DZH7W convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 26 Apr 2011 03:59:22 -0400
Message-Id: <4DB69776020000780003E19E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 26 Apr 2011 08:59:18 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <torvalds@linux-foundation.org>
Cc: <akpm@linux-foundation.org>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V8 0/8] Cleancache
References: <20110414211531.GA27661@ca-server1.us.oracle.com>
In-Reply-To: <20110414211531.GA27661@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.04.11 at 23:15, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> [PATCH V8 0/8] Cleancache
> 
> This is a courtesy repost to lkml and linux-mm.  As of 2.6.39-rc1,
> Linus has said that he will review cleancache but hasn't yet, so
> I am updating the patchset to the very latest bits.

Following your request to Dan, I just wanted to let you know that
we've been carrying a variant of this code since 2.6.31 in our
consumer and enterprise product (Xen) kernels. It would therefore
simplify our kernel maintenance if this got merged in the
foreseeable future.

Regards, Jan


