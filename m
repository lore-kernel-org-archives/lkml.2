Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2ACXLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:11:22 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38468 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2ACXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:11:19 -0500
Message-ID: <1325632265.3037.60.camel@work-vm>
Subject: Re: [03/67] rtc: Expire alarms after the time is set.
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Date: Tue, 03 Jan 2012 15:11:05 -0800
In-Reply-To: <20120103224741.GA7373@suse.de>
References: <20120103223031.542760681@clark.kroah.org>
	 <1325630765.3037.43.camel@work-vm> <20120103224741.GA7373@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010323-2398-0000-0000-00000325E214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 14:47 -0800, Greg KH wrote:
> On Tue, Jan 03, 2012 at 02:46:05PM -0800, John Stultz wrote:
> > On Tue, 2012-01-03 at 14:29 -0800, Greg KH wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This one is having problems upstream. Please hold off on it.
> 
> Hold off until when?  I'll just drop it for now.  If it ever gets worked
> out, please let stable@vger.kernel.org know about it and I'll handle it
> then.

Yea. I'm working on it now. As soon as we have a fix upstream I'll ping
you and you can grab both this and the fix together.

thanks
-john


