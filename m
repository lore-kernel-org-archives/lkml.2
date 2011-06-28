Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929Ab1F1SVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:21:38 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50709 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1F1SUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:20:43 -0400
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature
 sensor.
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Fubo Chen <fubo.chen@gmail.com>
CC: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTim=9ygJScqy12PQXNPBStSgPbpedQ@mail.gmail.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
	 <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
	 <6E4D2678AC543844917CA081C9D6B33F04CF4FFC@XMB-AMS-103.cisco.com>
	 <BANLkTim=9ygJScqy12PQXNPBStSgPbpedQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 28 Jun 2011 11:19:48 -0700
Message-ID: <1309285188.12139.1.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 13:50 -0400, Fubo Chen wrote:
> On Mon, Jun 27, 2011 at 9:04 AM, Stijn Devriendt (sdevrien)
> <sdevrien@cisco.com> wrote:
> >> On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
> >> > +       } else
> >> > +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
> >>
> >> No kernel coder writes like this. Has this ever been run through
> >> checkpatch ?
> > It has. Unfortunately this is just the coding style in the whole
> > driver. I believe it's better to have a consistent file rather
> > than 3 different styles.
> 
> Makes sense to me. By the way, it's not forbidden to clean up unusual
> coding style from other developers.
> 
Yes, but as separate patch. Please feel free to submit such a patch.

Thanks,
Guenter


