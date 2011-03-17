Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1CQSCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:02:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab1CQSCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:02:14 -0400
Date: Thu, 17 Mar 2011 11:02:04 -0700
From: Greg KH <gregkh@suse.de>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Greg Banks <gnb@fmeh.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>, mingo@elte.hu,
        akpm@linux-foundation.org
Subject: Re: [PATCH 05/50] Dynamic debug: Add more flags
Message-ID: <20110317180204.GA15205@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
 <1300309888-5028-5-git-send-email-gregkh@suse.de>
 <20110317175607.GD2648@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317175607.GD2648@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:56:08PM -0400, Jason Baron wrote:
> On Wed, Mar 16, 2011 at 02:10:43PM -0700, Greg Kroah-Hartman wrote:
> > Add flags that allow the user to specify via debugfs whether or not the
> > module name, function name, line number and/or thread ID have to be
> > included in the printed message.
> 
> This piece is going to conflict with the jump label update patches, I'm
> trying to get into .39. The 'if (unlikely(descriptor.enabled))' bit is
> now: 'if (DDEBUG_BRANCH(descriptor.enabled))'. So its a small conflict,
> but they wouldn't merge together. So we need to adjust either one (and
> make sure they're applied in the correct orer), or drop one.

This has been in linux-next for months now, where were the jump label
patches tested that missed this?  Why wasn't your patches in linux-next
before the merge window opened?  That's a requirement for .39 stuff,
right?

Also, this is already in Linus's tree so you will have to handle the
merge issue on your side now.

thanks,

greg k-h
