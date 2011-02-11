Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1BKHHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:07:39 -0500
Received: from [65.115.85.73] ([65.115.85.73]:40160 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab1BKHHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:07:38 -0500
Date: Thu, 10 Feb 2011 23:06:42 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot problen with next-20110211
Message-ID: <20110211070642.GA9512@dtor-ws.eng.vmware.com>
References: <20110211172254.8aa4d816.sfr@canb.auug.org.au>
 <20110211065731.GA8861@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211065731.GA8861@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:57:31PM -0800, Dmitry Torokhov wrote:
> Hi Stephen,
> 
> On Thu, Feb 10, 2011 at 10:22:54PM -0800, Stephen Rothwell wrote:
> > 
> > Maybe the module parameter alignment patches?  That is a very strange
> > parameter name (it is the same in the other messages).
> 
> Yes, I think it is... I wonder why I did not see it locally.  Let me try
> to fix that...
> 

Gah, it is better Rusty drops the module param alignment patch so I can
redo it properly. The module case is completely broken as it still
operates with assumption that __param section contains full structures
and not pointers.

-- 
Dmitry

