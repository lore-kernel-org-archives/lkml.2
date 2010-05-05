Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0EEWEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:04:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab0EEWES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:04:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 6 May 2010 00:05:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
References: <20100505185225.GA4411@srcf.ucam.org> <201005052244.03225.rjw@sisk.pl> <20100505215711.GA4838@opensource.wolfsonmicro.com>
In-Reply-To: <20100505215711.GA4838@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060005.01215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Mark Brown wrote:
> On Wed, May 05, 2010 at 10:44:03PM +0200, Rafael J. Wysocki wrote:
> 
> > To me, the above may be summarized that in your opinion some components of
> > the system will generally need to stay powered when it's suspended
> > opportunistically, so we need an interface to specify which components they are.
> > Is that correct?
> 
> Yes, though I think I'd be inclined to treat the problem orthogonally to
> opportunistic suspend to allow more flexibility in use and since
> treating it as part of opportunistic suspend would imply that there's
> some meaningful difference between the end result of that and a manual
> suspend which AIUI there isn't.

No, there's no such difference.

So, gnerenally, we may need a mechanism to specify which components of the
system need to stay powered while the whole system is suspended (in addition to
wakeup devices, that is).

That certainly I can agree with.

I'm not sure, however, in what way this is relevant to the $subject patchset.

Rafael
