Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0LAADQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:03:16 -0500
Received: from SMTP02.SRV.CS.CMU.EDU ([128.2.217.197]:63248 "EHLO
	smtp02.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0LAADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:03:15 -0500
Date: Tue, 30 Nov 2010 19:03:00 -0500
From: Eric Cooper <ecc@cmu.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] add netdev led trigger
Message-ID: <20101201000300.GJ21496@localhost>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>,
	Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org
References: <1290998056-8310-1-git-send-email-ecc@cmu.edu>
 <87ipzgl9k8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipzgl9k8.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:15:51AM +0100, Andi Kleen wrote:
> Using the device name as an identifier is not reliable, they may not
> be unique.

I'm confused about this -- how else can the user specify the desired network
interface?

> rwlocks are deprecated.

In favor of what?  Should I use a spinlock?

Thanks for the feedback.

-- 
Eric Cooper             e c c @ c m u . e d u
