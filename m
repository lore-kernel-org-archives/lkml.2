Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1LNOVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1LNOVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:21:03 -0500
Date: Wed, 14 Dec 2011 12:20:26 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nate Custer <nate@cpanel.net>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: kvm deadlock
Message-ID: <20111214142026.GA21670@amt.cnet>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <20111214140027.GF18317@amt.cnet>
 <4EE8AC88.1040205@redhat.com>
 <20111214140612.GG18317@amt.cnet>
 <7E2A4D2C-68BD-47E8-8079-37AE152D77B4@cpanel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E2A4D2C-68BD-47E8-8079-37AE152D77B4@cpanel.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:17:45AM -0600, Nate Custer wrote:
> 
> On Dec 14, 2011, at 8:06 AM, Marcelo Tosatti wrote:
> > I don't know. Its a hang ? It could be memory corruption (of the timer
> > olist) instead of a bogus NMI actually, the second.
> 
> 
> What is pasted in the second paste is what came scrolling across the console right before the end of all responsiveness. It came from a dmesg dump, the next dmesg command was not accepted via ssh and the console attached showed the same stack trace. At that point the system refused to respond to any direct keyboard input, including the SysRq commands that I expected to work after a core dump. 
> 
> The issue happened with two servers (same hardware, same build group so there is a chance of a bad hardware batch). Switching to an older kernel/kvm setup in RHEL 6.2 has corrected the issue, which suggests a software issue to me.

Right. Perhaps try an older upstream kernel to find a culprit then.

