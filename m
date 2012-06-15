Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2FOTKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab2FOTKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:10:42 -0400
Date: Fri, 15 Jun 2012 15:09:59 -0400
From: Dave Jones <davej@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: missing leap second patches in stable.
Message-ID: <20120615190958.GA9864@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	John Stultz <john.stultz@linaro.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <20120615152007.GA11793@redhat.com>
 <4FDB8382.8090501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDB8382.8090501@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:48:34AM -0700, John Stultz wrote:
 > On 06/15/2012 08:20 AM, Dave Jones wrote:
 > > Should these be in -stable ? Looks like all the other recent changes
 > > in that area are present.  With the leap second just two weeks away,
 > > it seems like they should be.
 > >
 > > Looks like 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d is in 3.4-stable,
 > > (haven't checked earlier -stable trees).
 > 
 > So the second patch has been sent out for stable review as of yesterday. 
 > So it should be on its way, but you're right that I forgot to CC stable 
 > on the first TAI offset fix.
 > 
 > I'll generate the patch and send it to Greg.  Thanks for the close 
 > review here!

fwiw, I did a test on 3.5rc2 yesterday where I forced a fake leap second at midnight.
Nothing untoward happened, unlike the previous ones :-)

	Dave

