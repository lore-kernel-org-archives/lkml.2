Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab1JCXVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:21:22 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:53154 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751170Ab1JCXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:21:20 -0400
Date: Mon, 3 Oct 2011 16:21:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Paulo Zanoni <przanoni@gmail.com>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] PCH reference clock cleanups
Message-ID: <20111003162108.07c6b9bb@jbarnes-desktop>
In-Reply-To: <yun7h4lmzon.fsf@aiko.keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
	<1317103906-4649-1-git-send-email-keithp@keithp.com>
	<CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
	<20111003141423.0ff5447c@jbarnes-desktop>
	<yun7h4lmzon.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Oct 2011 16:18:48 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Mon, 3 Oct 2011 14:14:23 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Now... is keeping the various refclks enabled costing us any power?
> > IOW, should we be trying to disable them when everything has been
> > DPMS'd off too?
> 
> That's the same as tracking usage and enabling/disabling on the fly as
> modes are set. I think it's possible, but I'd like to have the 'simpler'
> fix present before we try a power saving move.

Agreed; fortunately shutting everything off when no outputs are
active should be simpler than trying flip the bits on & off every mode
set. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
