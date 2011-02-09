Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1BITyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:54:24 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:6122
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab1BITyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:54:21 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2dK1432N98dN9371Pzz1202hzzz2fh637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D52F0D0.9020609@am.sony.com>
Date: Wed, 9 Feb 2011 11:53:52 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Frank Rowand <frank.rowand@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
References: <4D51D341.3040209@am.sony.com> <20110209114137.GA10163@opensource.wolfsonmicro.com> <201102091807.03094.rjw@sisk.pl> <4D52DD81.7050401@am.sony.com> <20110209184010.GB23747@opensource.wolfsonmicro.com> <4D52E441.2000805@am.sony.com> <20110209192506.GC23747@opensource.wolfsonmicro.com>
In-Reply-To: <20110209192506.GC23747@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 11:25 AM, Mark Brown wrote:
> On Wed, Feb 09, 2011 at 11:00:17AM -0800, Frank Rowand wrote:
> 
>> and my understanding of this proposal was a goal to remove the ability
>> to have CONFIG_PM disabled, which results in increased memory usage
>> for some configurations.
> 
> Not really, the goal was to simplify the PM config options to ones that
> are actually useful and cut down on the number of silly combinations
> that the randconfigs turn up.  CONFIG_PM is there mostly for historical
> reasons, it doesn't really mean much by itself except as a gate to other
> options.

I'm confused.  Do you plan to retain the option to
turn off PM features completely, or not?  I thought that's
what CONFIG_PM did today.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

