Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab0LVKSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:18:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45333 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0LVKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=RDLYof285Tj9GprzsIp6JFUYMzLvEH9lYfmCsqL1T4Yasmfs0vMUuag46V92FudX1K
         TmcnuAGff6pn7GCKOmECUj0gv3BoLvMiC6fx4lCkNLcdHnVcQBQ1g/S2KyvxdzfXI2lc
         F4Q21LJ5ezeS1XOPNHbWv2In3G1qWCAudBnGo=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, B02280@freescale.com
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
	<87bp4eb5r5.fsf@lechat.rtp-net.org>
Date: Wed, 22 Dec 2010 11:17:59 +0100
In-Reply-To: <87bp4eb5r5.fsf@lechat.rtp-net.org> (Arnaud Patard's message of
	"Wed, 22 Dec 2010 08:56:14 +0100")
Message-ID: <87ipymun54.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arnaud" == Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org> writes:

 Arnaud> Sascha Hauer <s.hauer@pengutronix.de> writes:
 Arnaud> Hi,

 >> The following series adds i.MX51 framebuffer support based on the
 >> IPUv3. It is not perfect but I decided it is good enough to open it
 >> for a wider audience and collect first reviews. I tested this on a
 >> babbage board using both outputs (VGA/DVI) with different
 >> resolutions up to 1680x1050 and different colour depths.  I also
 >> tested it on one custom board using a fixed display setting.

 Arnaud> After adding code to my efika sb machine file and your patchset, I've
 Arnaud> seen the light. Err, no. It was a penguin and a login prompt.  I guess
 Arnaud> it means your patchset is working here.

Cool. Care to submit that machine file support?

-- 
Bye, Peter Korsgaard
