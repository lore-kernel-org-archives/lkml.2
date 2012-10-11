Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2JKId4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:33:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36824 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2JKIdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:33:51 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v3] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Topic: [PATCH v3] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Index: AQHNm/hbnO/BdDsdFEGUc+x5xfaG4JeeWzyAgACJpQCAFPctAA==
Date: Thu, 11 Oct 2012 08:32:21 +0000
Deferred-Delivery: Thu, 11 Oct 2012 08:32:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CB92A@DBDE01.ent.ti.com>
References: <1348670827-5720-1-git-send-email-avinashphilip@ti.com>
 <20120927143309.02614908.akpm@linux-foundation.org>
 <20120928054548.GB10237@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120928054548.GB10237@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {CAE3E888-951F-4D27-89B6-1C41A0345EFC}
x-cr-hashedpuzzle: KShr PSM1 SiZv VsEY dreT eGEc tVB9 AAV/OA== AAxa3g==
 AB3/Kg== ACu/PA== AEGlVg== AIIYtQ== AKbpXw== AK0rkg==
 AN6ekQ==;11;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGIAcgBvAG8AbgBpAGUAQABvAHAAZQBuAHMAbwB1AHIAYwBlAC4AdwBvAGwAZgBzAG8AbgBtAGkAYwByAG8ALgBjAG8AbQA7AGQAZQB2AGkAYwBlAHQAcgBlAGUALQBkAGkAcwBjAHUAcwBzAEAAbABpAHMAdABzAC4AbwB6AGwAYQBiAHMALgBvAHIAZwA7AGcAcgBhAG4AdAAuAGwAaQBrAGUAbAB5AEAAcwBlAGMAcgBlAHQAbABhAGIALgBjAGEAOwBsAGkAbgB1AHgALQBkAG8AYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAbwBiAC4AaABlAHIAcgBpAG4AZwBAAGMAYQBsAHgAZQBkAGEALgBjAG8AbQA7AHIAbwBiAEAAbABhAG4AZABsAGUAeQAuAG4AZQB0ADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0ADsAcwBoAGEAdwBuAC4AZwB1AG8AQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAdABoAGkAZQByAHIAeQAuAHIAZQBkAGkAbgBnAEAAYQB2AGkAbwBuAGkAYwAtAGQAZQBzAGkAZwBuAC4AZABlAA==;Sosha1_v1;7;{CAE3E888-951F-4D27-89B6-1C41A0345EFC};YQB2AGkAbgBhAHMAaABwAGgAaQBsAGkAcABAAHQAaQAuAGMAbwBtAA==;Thu,
 11 Oct 2012 08:32:00
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAMwBdACAAcAB3AG0AXwBiAGEAYwBrAGwAaQBnAGgAdAA6ACAAQQBkAGQAIABkAGUAdgBpAGMAZQAgAHQAcgBlAGUAIABzAHUAcABwAG8AcgB0ACAAZgBvAHIAIABMAG8AdwAgAFQAaAByAGUAcwBoAG8AbABkACAAQgByAGkAZwBoAHQAbgBlAHMAcwA=
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:15:48, Thierry Reding wrote:
> On Thu, Sep 27, 2012 at 02:33:09PM -0700, Andrew Morton wrote:
> > On Wed, 26 Sep 2012 20:17:07 +0530
> > "Philip, Avinash" <avinashphilip@ti.com> wrote:
> > 
> > > Some back lights perform poorly when driven by a PWM with a short
> > > duty-cycle. For such devices, the low threshold can be used to specify a
> > > lower bound for the duty-cycle and should be chosen to exclude the
> > > problematic range.
> > > 
> > > Add device tree probing support for lth_brightness putting
> > > low-threshold-brightness as optional property.
> > > 
> > > ...
> > >
> > > --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > > +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > > @@ -14,6 +14,15 @@ Required properties:
> > >  Optional properties:
> > >    - pwm-names: a list of names for the PWM devices specified in the
> > >                 "pwms" property (see PWM binding[0])
> > > +  - low-threshold-brightness: brightness threshold low level. Low threshold
> > > +    brightness set to value so that backlight present on low end of
> > > +    brightness.
> > > +    Some panels, backlight would absent if duty percentage of PWM wave is less
> > > +    than certain level (say 20%). By setting low-threshold-brightness to a
> > > +    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
> > > +    is max). On setting low-threshold-brightness, range of brightness-levels
> > > +    is calculated in a region of low-threshold-brightness to brightness-levels
> > > +    max.
> > 
> > hoo boy, that's hard to follow.  How does this look?
> > 
> > --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix
> > +++ a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > @@ -14,15 +14,15 @@ Required properties:
> >  Optional properties:
> >    - pwm-names: a list of names for the PWM devices specified in the
> >                 "pwms" property (see PWM binding[0])
> > -  - low-threshold-brightness: brightness threshold low level. Low threshold
> > -    brightness set to value so that backlight present on low end of
> > -    brightness.
> > -    Some panels, backlight would absent if duty percentage of PWM wave is less
> > -    than certain level (say 20%). By setting low-threshold-brightness to a
> > -    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
> > -    is max). On setting low-threshold-brightness, range of brightness-levels
> > -    is calculated in a region of low-threshold-brightness to brightness-levels
> > -    max.
> > +  - low-threshold-brightness: brightness threshold low level. Sets the lowest
> > +    brightness value.
> > +    On some panels the backlight misbehaves if the duty cycle percentage of the
> > +    PWM wave is less than a certain level (say 20%).  In this example the user
> > +    can set low-threshold-brightness to a value above 50 (ie, 20% of 255), thus
> > +    preventing the PWM duty cycle from going too low.
> > +    On setting low-threshold-brightness the range of brightness levels is
> > +    calculated in the range low-threshold-brightness to the maximum value in
> > +    brightness-levels, described above.
> >  
> >  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> >  
> > 
> > 
> > Also, I'm wondering if we really needed a new property - couldn't one
> > do this simply by setting brightness-levels to 50..255?
> 
> Yes. This was discussed in the thread that followed the posting of this
> patch's v2. We've decided to drop it and go with brightness-levels only
> for device tree data. Eventually all existing users should convert to
> that as well so we can remove some of the cruft from the platform data
> up.

Andrew/Thierry,

It was decided that patch as dropped and still see it in linux-next.
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=1801ff7f87131190b0a469c26bd7c829601e198c

Thanks
Avinash

> 
> Thierry
> 

