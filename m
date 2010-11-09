Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0KIUfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:35:09 -0500
Received: from imr4.ericy.com ([198.24.6.8]:57910 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0KIUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:35:06 -0500
Subject: Re: [06/32] drivers/hwmon/asus_atk0110.c: Use pr_fmt and pr_<level>
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Joe Perches <joe@perches.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=cTAGuCyk4S-1rscbMUmOm_6X43L7hQTBFmL4y@mail.gmail.com>
References: <506bc745e46020fb99159fd73288d3b0202c99cf.1287556801.git.joe@perches.com>
	 <20101109163740.GA14733@ericsson.com>
	 <AANLkTi=cTAGuCyk4S-1rscbMUmOm_6X43L7hQTBFmL4y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 12:34:11 -0800
Message-ID: <1289334851.22931.223.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 15:15 -0500, Luca Tettamanti wrote:
> On Tue, Nov 9, 2010 at 5:37 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > On Wed, Oct 20, 2010 at 06:51:30AM -0000, Joe Perches wrote:
> >> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> >> Converted printks to pr_<level>
> >> Coalesced any long formats
> >> Removed prefixes from formats
> >>
> >> Signed-off-by: Joe Perches <joe@perches.com>
> >>
> > Applied.
> >
> > On a side note, I let the long lines go through as long as checkpatch doesn't complain.
> 
> I lost sight of the discussion, but I thought that a better solution
> was to put the define for pr_fmt in a common header instead of
> scattering it in all the drivers.
> 
We went back and forth on it, and concluded that Joe's current approach,
while not optimal, is still the best - ie make the changes as he
proposed and get rid of the pr_fmt defines at the very end, after all
individual files have been changed. Everything else is just too
intrusive.

Guenter


