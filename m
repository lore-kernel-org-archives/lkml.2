Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1FZUWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:22:23 -0400
Received: from imr4.ericy.com ([198.24.6.8]:52311 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab1FZUUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:20:55 -0400
Date: Sun, 26 Jun 2011 13:20:00 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fubo Chen <fubo.chen@gmail.com>
CC: "sdevrien@cisco.com" <sdevrien@cisco.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature
 sensor.
Message-ID: <20110626202000.GA9067@ericsson.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
 <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 03:54:37PM -0400, Fubo Chen wrote:
> On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
> > +       } else
> > +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
> 
> No kernel coder writes like this. Has this ever been run through checkpatch ?
> 
What a nice comment. Quite obviously _you_ did not run the patch through checkpatch
to back up yout claim. I did:

total: 0 errors, 0 warnings, 151 lines checked

The code format is in line with other if/else constructs in the same function,
which coincidentially also pass through checkpatch. Which you did not bother
checking either (neither the format of the code in lm90.c nor the results
of checkpatch over it).

Before making statements like this, you might want to consider spending some time
with the actual code - amongst others to see if the new code fits into the structure
of existing code.

If you want to improve code formatting in this or in other files, I would suggest 
to submit patches.

Thanks,
Guenter
