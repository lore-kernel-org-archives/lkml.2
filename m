Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab2CVP3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964892Ab2CVP2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:28:54 -0400
Date: Thu, 22 Mar 2012 11:28:50 -0400
From: Dave Jones <davej@redhat.com>
To: John Stultz <john.stultz@linaro.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: Adjusting tsc more then 11%
Message-ID: <20120322152850.GA31589@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	John Stultz <john.stultz@linaro.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20120305154411.GA29668@redhat.com>
 <1330972323.2191.74.camel@work-vm>
 <20120305192338.GA30491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305192338.GA30491@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:23:38PM -0500, Dave Jones wrote:

 >  > Do you know if this is an occasional thing on any of the affected
 >  > hardware, or if it happens after every reboot?
 > 
 > Out of all the people running the Fedora 17 alpha, this has only shown
 > up those four times, so it does seem to be a rare thing.
 > I suspect we'll get more instances of it as more people start testing.

As suspected, the reports are starting to come in more regularly.

See the duplicates marked at https://bugzilla.redhat.com/show_bug.cgi?id=798600 

	Dave

