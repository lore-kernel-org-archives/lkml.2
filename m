Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1LSQo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:44:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41894 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LSQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:44:27 -0500
Date: Mon, 19 Dec 2011 08:44:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Matthijs Kooijman <matthijs@stdin.nl>,
        Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
 (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111219164421.GC24519@google.com>
References: <20110907085037.GX10237@login.drsnuggles.stderr.nl>
 <20110911040826.GP29319@htj.dyndns.org>
 <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
 <20111026182650.GL14392@login.drsnuggles.stderr.nl>
 <20111026222510.GK24261@google.com>
 <20111028134743.GU14392@login.drsnuggles.stderr.nl>
 <20111030203503.GB7696@google.com>
 <20111031092812.GD14392@login.drsnuggles.stderr.nl>
 <20111031152612.GG7696@google.com>
 <20111219111208.GP15486@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219111208.GP15486@login.drsnuggles.stderr.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 19, 2011 at 12:12:08PM +0100, Matthijs Kooijman wrote:
> I've been running the tj/misc.git kernel (a3b96625209aae) for six weeks
> now, the suspend problems have not occured once since then. I suspect
> it's safe to say that the problems are fixed in that kernel.
> 
> Are these fixes pushed to the main kernel tree yet?

Yeah, they're all in mainline now and 3.2 should have it fixed.  3.2
is already at rc6, so you might want to give it a try.  It would be
nice to backport the changes to -stable too but it's quite invasive.
Hmmm...

Thanks.

-- 
tejun
