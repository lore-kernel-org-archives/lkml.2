Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1KDLky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1KDLkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:40:53 -0400
Date: Fri, 4 Nov 2011 13:40:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
Message-ID: <20111104114033.GA21308@redhat.com>
References: <1320259767.22582.2.camel@lappy>
 <8762j2t19l.fsf@rustcorp.com.au>
 <1320309203.29407.1.camel@lappy>
 <87lirwrzlg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lirwrzlg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 08:14:43PM +1030, Rusty Russell wrote:
> > > 3) If we're changing the queue layout, it's a chance to fix a
> > >    longstanding bug: let the guest notify the host of preferred
> > >    queue size and alignment.
> > 
> > Yup, we can do that.

We don't need to change all of layout for that - just add another field
in the common config structure to supply the alignment.

> The seabios guys will definitely thank you!

-- 
MST
