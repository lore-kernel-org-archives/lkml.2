Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1GKXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab1GKXZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:25:26 -0400
Date: Mon, 11 Jul 2011 19:25:17 -0400
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Underclock checks
Message-ID: <20110711232517.GC20367@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
	Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <1310114243.2940.3.camel@phoenix>
 <4E1B745A.5000802@interia.pl>
 <4E1B8404.1050909@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1B8404.1050909@interia.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:15:16AM +0100, Rafał Bilski wrote:

Your email client word-wrapped your patch so it won't apply.
When you resend, there's a few small typos/grammar..

 > +    /* Check for systems using underclocked CPU */
 > +    if (!freq_failsafe_off && max_multiplier != current_multiplier) {
 > +        printk(KERN_INFO "eps: Your processor is running at
 > different then "
 > +            "its maximum frequency.\n");

"is running at a different frequency than its maximum" reads a little clearer.

 > +        printk(KERN_INFO "eps: Some systems use underclocked CPU's\n");
 > +        printk(KERN_INFO "eps: Use of \"e_powersaver\" on them may cause "
 > +            "irreperable damage.\n");

'irreparable'.

 > +    if (!voltage_failsafe_off && max_voltage != current_voltage) {
 > +        printk(KERN_INFO "eps: Your processor is running at
 > different then "
 > +            "its maximum voltage.\n");

similar to above.

	Dave
