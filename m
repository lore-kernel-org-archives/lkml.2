Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2EWUqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:46:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759640Ab2EWUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:46:49 -0400
Date: Wed, 23 May 2012 23:46:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120523204311.GB350@redhat.com>
References: <20120521163727.GA13337@redhat.com>
 <alpine.LFD.2.02.1205211940030.3231@ionos>
 <20120521215127.GH17031@redhat.com>
 <alpine.LFD.2.02.1205220012020.3231@ionos>
 <20120521222449.GJ17031@redhat.com>
 <alpine.LFD.2.02.1205220044460.3231@ionos>
 <4FBB6E8B.8020200@redhat.com>
 <20120523144846.GA26974@gmail.com>
 <4FBCFC4A.7070303@redhat.com>
 <alpine.LFD.2.02.1205232140570.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205232140570.3231@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:10:27PM +0200, Thomas Gleixner wrote:
> Replying on a still polite reminder with a sloppy "I just took what's
> there and implemeted the optimization which I was tasked with" is even
> more of an offense.

Ow.  That 'not my fault' line was a joke.

-- 
MST
