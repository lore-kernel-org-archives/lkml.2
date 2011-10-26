Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1JZWZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 18:25:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46740 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1JZWZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 18:25:16 -0400
Date: Wed, 26 Oct 2011 15:25:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Matthijs Kooijman - Brevidius <matthijs@brevidius.nl>,
        Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
 (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111026222510.GK24261@google.com>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110903221456.GA2877@elie>
 <20110904024244.GB3083@htj.dyndns.org>
 <87y5y37o7h.fsf@servo.factory.finestructure.net>
 <20110906174524.GN18425@mtj.dyndns.org>
 <20110907085037.GX10237@login.drsnuggles.stderr.nl>
 <20110911040826.GP29319@htj.dyndns.org>
 <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
 <20111026182650.GL14392@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026182650.GL14392@login.drsnuggles.stderr.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 26, 2011 at 08:26:50PM +0200, Matthijs Kooijman - Brevidius wrote:
> Hi folks,
> 
> it seems this same problem also occurs with udisks-daemon, though the
> behaviour is slightly different (it seems to hang even before
> undocking, I _think_).
> 
> Anyway, here's the dmesg output when trying to suspend:

Can you please turn on CONFIG_FRAME_POINTER, trigger the problem, wait
for some minutes and then do sysrq-t and report the dmesg output?
This could be from DEAD state handling race currently being addressed
in upstream.

Thanks.

-- 
tejun
