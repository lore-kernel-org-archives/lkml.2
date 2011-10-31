Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab1JaP0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:26:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40477 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab1JaP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:26:20 -0400
Date: Mon, 31 Oct 2011 08:26:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Matthijs Kooijman <matthijs@stdin.nl>,
        Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
 (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111031152612.GG7696@google.com>
References: <87y5y37o7h.fsf@servo.factory.finestructure.net>
 <20110906174524.GN18425@mtj.dyndns.org>
 <20110907085037.GX10237@login.drsnuggles.stderr.nl>
 <20110911040826.GP29319@htj.dyndns.org>
 <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
 <20111026182650.GL14392@login.drsnuggles.stderr.nl>
 <20111026222510.GK24261@google.com>
 <20111028134743.GU14392@login.drsnuggles.stderr.nl>
 <20111030203503.GB7696@google.com>
 <20111031092812.GD14392@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031092812.GD14392@login.drsnuggles.stderr.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 31, 2011 at 10:28:12AM +0100, Matthijs Kooijman wrote:
> I'm running this kernel now and the problem seems to have disappeared.
> I've done a dozen or so undocks and suspends, without any problems.
> Also, the "udisks-daemon" process in ps now says "not polling any
> devices" after undocking, where it would continue to say "polling sr0"
> before.

Ah, good to hear.

> I'll continue running this kernel for a while and inform you if the
> problem resurfaces.
> 
> Any other tests I should be doing?

Not at the moment, please update after testing some more.

Thank you.

-- 
tejun
