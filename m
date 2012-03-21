Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2CUIDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:03:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38972 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2CUIDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:03:19 -0400
Date: Wed, 21 Mar 2012 01:03:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Donggeun Kim <dg77.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd and
 input trees related)
Message-ID: <20120321080313.GA12410@core.coreip.homeip.net>
References: <20120321182930.6f75199b7406044669891a14@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321182930.6f75199b7406044669891a14@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Mar 21, 2012 at 06:29:30PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/leds/leds-max8997.c:18:0:
> include/linux/mfd/max8997.h:205:6: error: nested redefinition of 'enum max8997_haptic_motor_type'
> include/linux/mfd/max8997.h:205:6: error: redeclaration of 'enum max8997_haptic_motor_type'
> include/linux/mfd/max8997.h:134:6: note: originally defined here
> include/linux/mfd/max8997.h:206:2: error: redeclaration of enumerator 'MAX8997_HAPTIC_ERM'
> include/linux/mfd/max8997.h:135:2: note: previous definition of 'MAX8997_HAPTIC_ERM' was here
> include/linux/mfd/max8997.h:207:2: error: redeclaration of enumerator 'MAX8997_HAPTIC_LRA'
> include/linux/mfd/max8997.h:136:2: note: previous definition of 'MAX8997_HAPTIC_LRA' was here
> include/linux/mfd/max8997.h:210:6: error: nested redefinition of 'enum max8997_haptic_pulse_mode'
> include/linux/mfd/max8997.h:210:6: error: redeclaration of 'enum max8997_haptic_pulse_mode'
> include/linux/mfd/max8997.h:139:6: note: originally defined here
> include/linux/mfd/max8997.h:211:2: error: redeclaration of enumerator 'MAX8997_EXTERNAL_MODE'
> include/linux/mfd/max8997.h:140:2: note: previous definition of 'MAX8997_EXTERNAL_MODE' was here
> include/linux/mfd/max8997.h:212:2: error: redeclaration of enumerator 'MAX8997_INTERNAL_MODE'
> include/linux/mfd/max8997.h:141:2: note: previous definition of 'MAX8997_INTERNAL_MODE' was here
> include/linux/mfd/max8997.h:215:6: error: nested redefinition of 'enum max8997_haptic_pwm_divisor'
> include/linux/mfd/max8997.h:215:6: error: redeclaration of 'enum max8997_haptic_pwm_divisor'
> include/linux/mfd/max8997.h:144:6: note: originally defined here
> include/linux/mfd/max8997.h:216:2: error: redeclaration of enumerator 'MAX8997_PWM_DIVISOR_32'
> include/linux/mfd/max8997.h:145:2: note: previous definition of 'MAX8997_PWM_DIVISOR_32' was here
> include/linux/mfd/max8997.h:217:2: error: redeclaration of enumerator 'MAX8997_PWM_DIVISOR_64'
> include/linux/mfd/max8997.h:146:2: note: previous definition of 'MAX8997_PWM_DIVISOR_64' was here
> include/linux/mfd/max8997.h:218:2: error: redeclaration of enumerator 'MAX8997_PWM_DIVISOR_128'
> include/linux/mfd/max8997.h:147:2: note: previous definition of 'MAX8997_PWM_DIVISOR_128' was here
> include/linux/mfd/max8997.h:219:2: error: redeclaration of enumerator 'MAX8997_PWM_DIVISOR_256'
> include/linux/mfd/max8997.h:148:2: note: previous definition of 'MAX8997_PWM_DIVISOR_256' was here
> include/linux/mfd/max8997.h:241:8: error: redefinition of 'struct max8997_haptic_platform_data'
> include/linux/mfd/max8997.h:170:8: note: originally defined here
> 
> Caused by a bad merge of commits 104594b01ce7 ("Input: add driver support
> for MAX8997-haptic") from the input tree and 02b09703e7a4 ("mfd: Add
> platform data for MAX8997 haptic driver") from the mfd tree.

Sorry about this. I thought Samuel was going to revert the platform data
from his tree as he OKed applying the combined patch...

Thanks.

-- 
Dmitry
