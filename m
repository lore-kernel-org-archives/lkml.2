Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0CVV0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:26:35 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:38434 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0CVV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=L0rSalKiosDx8I+7UmYfkDi+j79fhA0FE1/NN0kxvBJ2Tc5nNAC934S3Jf+YaZ6rc5
         u5OG42QwjpSXGUK1vagzcOPVIjpXCCkvds7Vg2vx05+/EZCp7UXP7IaittWU7b9tVPSm
         rU9qQmkKpJWrE/cTlXcMbOry1h2m1JSJa9Vcc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RESEND] Re: [Kgdb-bugreport] [GIT PULL] V2 kdb / early debug (1 of 2) for 2.6.34
Date: Mon, 22 Mar 2010 14:26:25 -0700
User-Agent: KMail/1.13.1 (Linux/2.6.34-rc1; KDE/4.4.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, torvalds@linux-foundation.org,
       kgdb-bugreport@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
References: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com> <20100322130530.50e8de1e@jbarnes-piketon> <4BA7CF53.7040504@windriver.com>
In-Reply-To: <4BA7CF53.7040504@windriver.com>
MIME-Version: 1.0
Message-Id: <201003221426.25837.dmitry.torokhov@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 01:13:07 pm Jason Wessel wrote:
> On 03/22/2010 03:05 PM, Jesse Barnes wrote:
> > On Sat, 20 Mar 2010 21:14:24 -0500
> > 
> > Jason Wessel <jason.wessel@windriver.com> wrote:
> >> On 02/28/2010 11:09 PM, Jason Wessel wrote:
> >>> Linus please pull the kdb-merge tree which merges the kdb front end
> >>> into the kernel debug core for 7 architectures.
> >>> 
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.gi
> >>> t kdb-merge
> >> 
> >> What is the status of this pull request?  Was some part of the process
> >> missed here that there has been no response on this pull request?
> >> 
> >> Please let me know what is wrong here.   I have a number of other fixes
> >> pending to the tree at this point.
> >> 
> >> Would it be possible to merge part of the tree that is only related to
> >> kgdb, in particular the directory re-organization?
> > 
> > IIRC he still had some issues with the keyboard/input handling.  We
> > discussed it briefly a couple of weeks ago and he was worried about
> > potential duplication.
> 
> I worked with Dmitry Torokhov to come to some agreement with respect to
> the kdb keyboard handling.  This resulted in dropping one of the
> keyboard patches entirely, and it will be done another way.  There are
> RFC patches from me on this, as well as Dmitry's own RFC patches for
> sysrq handling.
> 
> The discussion with Dmitry also resulted in the cleanup of the current
> kdb low level PS/2 kdb keyboard driver to an acceptable state.  I was
> waiting to hear back on the response to the pull request before
> investing further effort here.  I am always open to suggestions of how
> to solve this tricky problem.
>

Yep, as far as input concerned I am satisfied with Jason's changes so
no need to block pull request on my account.
 
-- 
Dmitry
