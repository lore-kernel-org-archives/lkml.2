Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1LNPDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:03:06 -0500
Received: from mx1.cpanel.net ([208.74.121.68]:41116 "EHLO mx1.cpanel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1LNPDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:03:02 -0500
X-Greylist: delayed 2713 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 10:03:02 EST
Subject: Re: kvm deadlock
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Nate Custer <nate@cpanel.net>
In-Reply-To: <20111214140612.GG18317@amt.cnet>
Date: Wed, 14 Dec 2011 08:17:45 -0600
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Transfer-Encoding: 8BIT
Message-Id: <7E2A4D2C-68BD-47E8-8079-37AE152D77B4@cpanel.net>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <20111214140027.GF18317@amt.cnet> <4EE8AC88.1040205@redhat.com> <20111214140612.GG18317@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1084)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mx1.cpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cpanel.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 14, 2011, at 8:06 AM, Marcelo Tosatti wrote:
> I don't know. Its a hang ? It could be memory corruption (of the timer
> olist) instead of a bogus NMI actually, the second.


What is pasted in the second paste is what came scrolling across the console right before the end of all responsiveness. It came from a dmesg dump, the next dmesg command was not accepted via ssh and the console attached showed the same stack trace. At that point the system refused to respond to any direct keyboard input, including the SysRq commands that I expected to work after a core dump. 

The issue happened with two servers (same hardware, same build group so there is a chance of a bad hardware batch). Switching to an older kernel/kvm setup in RHEL 6.2 has corrected the issue, which suggests a software issue to me.

Nate Custer



