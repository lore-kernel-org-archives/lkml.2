Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2ACWtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:49:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab2ACWtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:49:18 -0500
Date: Tue, 3 Jan 2012 14:47:41 -0800
From: Greg KH <gregkh@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: Re: [03/67] rtc: Expire alarms after the time is set.
Message-ID: <20120103224741.GA7373@suse.de>
References: <20120103223031.542760681@clark.kroah.org>
 <1325630765.3037.43.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325630765.3037.43.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:46:05PM -0800, John Stultz wrote:
> On Tue, 2012-01-03 at 14:29 -0800, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> This one is having problems upstream. Please hold off on it.

Hold off until when?  I'll just drop it for now.  If it ever gets worked
out, please let stable@vger.kernel.org know about it and I'll handle it
then.

thanks,

greg k-h
