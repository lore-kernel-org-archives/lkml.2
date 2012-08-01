Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2HAMqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:46:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2HAMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:46:21 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=aqDLzf-sAsEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=SuqbO_6EAAAA:8 a=YogYXIzVkstchHFBgFUA:9 a=PUjeQqilurYA:10 a=l1dcLZD439IA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343825179.27983.76.camel@gandalf.stny.rr.com>
Subject: Re: awful kconfig help texts.
From: Steven Rostedt <rostedt@goodmis.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 01 Aug 2012 08:46:19 -0400
In-Reply-To: <50190B67.5050108@metafoo.de>
References: <20120731151600.GA19412@redhat.com>
	 <20120731170741.GA4735@x1.osrc.amd.com>
	 <20120731172638.GE16873@home.goodmis.org>
	 <20120731174249.GB4735@x1.osrc.amd.com>
	 <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de>
	 <20120801085644.GA21303@liondog.tnic> <5018F537.209@metafoo.de>
	 <20120801092625.GB21303@liondog.tnic> <5018F908.9090607@metafoo.de>
	 <20120801100455.GD21303@liondog.tnic> <50190B67.5050108@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 12:56 +0200, Lars-Peter Clausen wrote:

> You could do that by using a construct like below, but well...
> 
> config HAS_PWM
>     bool
> 
> config PWM
>     bool "PWM
>     depends on HAS_PWM
> 
> config PWM_CAN_BUILD_DRIVER_X
>     defbool I2C
>     select HAS_PWM
> 
> config PWM_DRIVER_X
>     tristate "PWM chip X support"
>     depends on PWM && PWM_CAN_BUILD_DRIVER_X
> 
> config PWM_CAN_BUILD_DRIVER_Y
>     defbool ARCH_Y
>     select HAS_PWM
> 
> config PWM_DRIVER_Y
>     tristate "PWM chip Y support"
>     depends on PWM && PWM_CAN_BUILD_DRIVER_Y

What selects the 'PWM_CAN_BUILD_DRIVER_FOO'?

-- Steve


