Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab0EDR3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:29:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51374 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab0EDR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pHMTtUTEyFQkWT1NIL/9txH7+Ror9LHJIHiKuxMEMBBRV11zX2KC+NUXjSja0clKHq
         B9Q4h8Vl92LgoTzqy9MWHHfJeRMBnjWcTNd4jU1A7CJu+bfOoF1narYUWkccOm+31G3e
         p06Y5GyxFE2ikbpmBpkupD0sIQh8ZkcmmsNOM=
Date: Tue, 4 May 2010 10:29:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
Message-ID: <20100504172903.GB29428@core.coreip.homeip.net>
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>
 <20100415232523.GA18263@core.coreip.homeip.net>
 <4BDFD356.7070008@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDFD356.7070008@bitmath.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 09:57:10AM +0200, Henrik Rydberg wrote:
> > It would be nice to use abs[ABS_MT_MAX - ABS_MT_TOUCH_MAJOR] to save
> > some memory.
> > 
> 
> Is it possible this was meant to read "ABS_MAX - ABS_MT_TOUCH_MAJOR"? It would
> explain my confusion.
> 

By ABS_MT_MAX I meant highest MT event currently defined. No need to go all
the way to ABS_MAX if there are no MT events defined there.

-- 
Dmitry
