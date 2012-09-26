Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2IZEhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 00:37:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42649 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2IZEhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 00:37:07 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Topic: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Index: AQHNl7dcczUdlqqMiEavEaWXq+POTpeT5POAgABctfCAAHP6gIAEaxEQgAEfCQCAAL+RgA==
Date: Wed, 26 Sep 2012 04:35:32 +0000
Deferred-Delivery: Wed, 26 Sep 2012 04:35:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9A8FA7@DBDE01.ent.ti.com>
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
 <505BF83D.8040201@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
 <505CA74B.2090405@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
 <50614CE2.7010301@wwwdotorg.org>
In-Reply-To: <50614CE2.7010301@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {76DD1339-2A99-4165-9F92-1711ED8FF33B}
x-cr-hashedpuzzle: H27l SwbS kKHw nnar ohgP tEGR /GOS /Ku/ ACP3vQ== AFOrhA==
 AGHTyQ== AIkE1A== AKPX6A== AKmuaQ== AK8cOQ==
 ALD21Q==;11;YgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAZABlAHYAaQBjAGUAdAByAGUAZQAtAGQAaQBzAGMAdQBzAHMAQABsAGkAcwB0AHMALgBvAHoAbABhAGIAcwAuAG8AcgBnADsAZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGQAbwBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBvAGIALgBoAGUAcgByAGkAbgBnAEAAYwBhAGwAeABlAGQAYQAuAGMAbwBtADsAcgBvAGIAQABsAGEAbgBkAGwAZQB5AC4AbgBlAHQAOwByAHAAdQByAGQAaQBlAEAAcgBwAHMAeQBzAC4AbgBlAHQAOwBzAGgAYQB3AG4ALgBnAHUAbwBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwBzAHcAYQByAHIAZQBuAEAAdwB3AHcAZABvAHQAbwByAGcALgBvAHIAZwA7AHQAaABpAGUAcgByAHkALgByAGUAZABpAG4AZwBAAGEAdgBpAG8AbgBpAGMALQBkAGUAcwBpAGcAbgAuAGQAZQA=;Sosha1_v1;7;{76DD1339-2A99-4165-9F92-1711ED8FF33B};YQB2AGkAbgBhAHMAaABwAGgAaQBsAGkAcABAAHQAaQAuAGMAbwBtAA==;Wed,
 26 Sep 2012 04:35:00
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAMgBdACAAcAB3AG0AXwBiAGEAYwBrAGwAaQBnAGgAdAA6ACAAQQBkAGQAIABkAGUAdgBpAGMAZQAgAHQAcgBlAGUAIABzAHUAcABwAG8AcgB0ACAAZgBvAHIAIABMAG8AdwAgAFQAaAByAGUAcwBoAG8AbABkACAAQgByAGkAZwBoAHQAbgBlAHMAcwA=
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:49:14, Stephen Warren wrote:
> On 09/24/2012 10:29 PM, Philip, Avinash wrote:
> > On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
> >> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> >>> Hi Stephen,
> >>>
> >>> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
> >>>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> >>>>> Some backlights perform poorly when driven by a PWM with a short
> >>>>> duty-cycle. For such devices, the low threshold can be used to specify a
> >>>>> lower bound for the duty-cycle and should be chosen to exclude the
> >>>>> problematic range.
> >>>>>
> >>>>> This patch adds support for an optional low-threshold-brightness
> >>>>> property.
> >>>>
> >>>>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> >>>>
> >>>>>  Optional properties:
> >>>>>    - pwm-names: a list of names for the PWM devices specified in the
> >>>>>                 "pwms" property (see PWM binding[0])
> >>>>> +  - low-threshold-brightness: brightness threshold low level. Low threshold
> >>>>> +    brightness set to value so that backlight present on low end of
> >>>>> +    brightness.
> >>>>
> >>>> For my education, why not just specify values above this value in the
> >>>> brightness-levels array; how do those two interact?
> >>>
> >>> Please find details from 
> >>> https://lkml.org/lkml/2012/7/18/284
> >>
> >> Hmm. That still doesn't really explain what this property does.
> >>
> >> I'm going to guess that if this property is present, and values in the
> >> brightness-levels property get scaled between the
> >> low-threshold-brightness and 255 instead of being used directly.
> > 
> > This is correct.
> > 
> >> But then, in the email you linked to, what does "But brightness-levels won't
> >> be uniformly divided" mean?
> > 
> > For some panels, backlight would absent on low end of brightness due to low
> > percentage in duty_cycle. Consider following example where backlight absent
> > for brightness levels from 0 - 51.
> > 
> > pwms = <&pwm 0 50000>;
> > brightness-levels = <0 51 53 56 62 75 101 152 255>; 
> > default-brightness-level = <6>;
> > 
> > So in the example, brightness-levels are set to have values for backlight present.
> > Here levels are not uniformly divided.
> 
> So why not just change the values so they /are/ what you want? After
> all, it's just data and you can put whatever values you want there. What
> is preventing you from doing this?

brightness_threshold_level was added to explore lth_brightness support already
present in non-DT case.
 
> 
> Perhaps e.g.:
> 
> brightness-levels = <0 101 106 112 124 150 202 304 511>;
> (just multiplying everything by N, for arbitrary N=2, to get extra
> precision)
> 
> ... plus whatever adjustments are required to make the data "uniformly
> divided", which I can't do in the example here since I'd need to know
> whatever non-linear equation characterizes the backlight's PWM % duty
> cycle to perceived brightness mapping.
> 
> The only thing that could be preventing this is mathematical precision.
> While all the PWM DT examples I've seen have brightness-levels range
> from 0..255, I don't think there is any such actual limit; you could
> range from say 0..1000000 if you wanted, right?

The observation is correct. There are no fixed levels, configure these values 
as required. This is a scale of division for brightness variation. A linear
division in brightness won't give much difference in high end of brightness-levels
scale. So adopting binary division in brightness-levels will allow better resolution
in brightness. 

> 
> >> Either way, the DT binding should explain exactly what this value is
> >> used for, and how it affects the interpretation of values in
> >> brightness-levels.
> > 
> > Is DT binding documentation a good place to explain this feature?
> > Initially Thierry suggested document option. So I left out.
> 
> The binding documents are supposed to be a standalone description of
> what the data in DT does; given general no-Linux-specific domain
> knowledge, the binding document should be detailed enough for someone to
> understand how to fill in the DT. So, yes, I think the binding document
> would be a great place to put such documentation.

I will add details.

Thanks
Avinash

> 

