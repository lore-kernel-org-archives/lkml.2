Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1IYA2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 20:28:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53013 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1IYA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 20:28:41 -0400
Date: Sat, 24 Sep 2011 19:28:32 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: trouble daemon <troubledaemon@gmail.com>
Cc: Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Possible PNP issue on Dell PowerEdge 4200 unless noapic used
Message-ID: <20110925002831.GA32152@elie>
References: <CAK82gMF0EbPiTATjPZ2-K5fCtuJHAXH2aJgpwCD5CRDLS2YpqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK82gMF0EbPiTATjPZ2-K5fCtuJHAXH2aJgpwCD5CRDLS2YpqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(just cc-ing linux-kernel so any work on this gets archived)
trouble daemon wrote:

> Greetings,
>
> Hello Adam and Bjorn. I am sending this email to you as suggested by
> Jonathan regarding a problem that I was having with Linux on a pair of
> old Dell PowerEdge 4200 machines that I own (yes, they still run!).
>
> I have left the most recent reply between Jonathan and I quoted below,
> but you can find the original bug report at the Debian bug tracker
> under bug #586494 [1]. As a brief recap, I have been required to use
> the noapic kernel option in these systems in order to allow them to
> boot, and appears to have originated after a commit to the kernel
> relating to EISA (although it has come to my attention now that PNP
> may be related as well).
>
> As suggested, I have attached a copy of the "quick & dirty" config I
> used for a vanilla 3.1.0-rc7 kernel I compiled, along with the boot
> log of the machine, and a diff against the apic log of a working boot
> of the same kernel when using noapic. One thing that I should mention
> is that on these dells, I also usually use the pnpbios=off option to
> hide the pesky warnings on boot, in addition to noapic.
>
> I hope these logs help you in some way. If there is anything else you
> might be interested in knowing or testing, don't hesitate to ask!

Original report: http://thread.gmane.org/gmane.linux.kernel/1000807
Logs: http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=86;bug=586494

> Dan McGrath
>
> PS - Not a problem Jonathan, thanks!
>
> [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586494
