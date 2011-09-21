Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1IURrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1IURrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:47:07 -0400
Date: Wed, 21 Sep 2011 14:46:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>, Anthony Liguori <anthony@codemonkey.ws>,
        avi@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org, Glauber Costa <glommer@gmail.com>,
        mjwolf@us.ibm.com
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Message-ID: <20110921174624.GB21677@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet>
 <4E5FDBDC.2030302@codemonkey.ws>
 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
 <20110909132955.GA19459@amt.cnet>
 <20110913204955.GD9096@mgebm.net>
 <20110915132614.GA7101@amt.cnet>
 <20110920190054.GA31415@mgebm.net>
 <20110920195514.GD32325@amt.cnet>
 <1316614268.16137.280.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316614268.16137.280.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 07:11:08AM -0700, Dave Hansen wrote:
> On Tue, 2011-09-20 at 16:55 -0300, Marcelo Tosatti wrote:
> > > and the wall clock stays behind my host wall clock by the amount of
> > > time it took to resume.
> > 
> > This is expected, similar to savevm/loadvm. 
> 
> That seems like pretty undesirable behavior to me.  It's too bad that it
> does that with savevm/loadvm, but is it really behavior that we want to
> spread?

Not really. savevm/loadvm has more widespread use, so a solution could
apply equally to both cases.

