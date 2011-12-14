Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1LNO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1LNO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:28:54 -0500
Message-ID: <4EE8B2A1.8060603@redhat.com>
Date: Wed, 14 Dec 2011 16:28:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nate Custer <nate@cpanel.net>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: kvm deadlock
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <20111214140027.GF18317@amt.cnet> <4EE8AC88.1040205@redhat.com> <20111214140612.GG18317@amt.cnet> <7E2A4D2C-68BD-47E8-8079-37AE152D77B4@cpanel.net>
In-Reply-To: <7E2A4D2C-68BD-47E8-8079-37AE152D77B4@cpanel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 04:17 PM, Nate Custer wrote:
> On Dec 14, 2011, at 8:06 AM, Marcelo Tosatti wrote:
> > I don't know. Its a hang ? It could be memory corruption (of the timer
> > olist) instead of a bogus NMI actually, the second.
>
>
> What is pasted in the second paste is what came scrolling across the console right before the end of all responsiveness. It came from a dmesg dump, the next dmesg command was not accepted via ssh and the console attached showed the same stack trace. At that point the system refused to respond to any direct keyboard input, including the SysRq commands that I expected to work after a core dump. 
>
> The issue happened with two servers (same hardware, same build group so there is a chance of a bad hardware batch). Switching to an older kernel/kvm setup in RHEL 6.2 has corrected the issue, which suggests a software issue to me.
>

If you can, please set up netconsole, which should give us complete
dmesg captures.

-- 
error compiling committee.c: too many arguments to function

