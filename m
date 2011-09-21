Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab1IUOLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:11:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40676 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1IUOLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:11:23 -0400
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by
 host
From: Dave Hansen <haveblue@us.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, Anthony Liguori <anthony@codemonkey.ws>,
        avi@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org, Glauber Costa <glommer@gmail.com>,
        mjwolf@us.ibm.com
In-Reply-To: <20110920195514.GD32325@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
	 <20110830122630.GA19450@amt.cnet> <4E5FDBDC.2030302@codemonkey.ws>
	 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
	 <20110909132955.GA19459@amt.cnet> <20110913204955.GD9096@mgebm.net>
	 <20110915132614.GA7101@amt.cnet> <20110920190054.GA31415@mgebm.net>
	 <20110920195514.GD32325@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 07:11:08 -0700
Message-ID: <1316614268.16137.280.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 16:55 -0300, Marcelo Tosatti wrote:
> > and the wall clock stays behind my host wall clock by the amount of
> > time it took to resume.
> 
> This is expected, similar to savevm/loadvm. 

That seems like pretty undesirable behavior to me.  It's too bad that it
does that with savevm/loadvm, but is it really behavior that we want to
spread?

-- Dave

