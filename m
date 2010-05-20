Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0ETLc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:32:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:28105 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0ETLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:32:55 -0400
Date: Thu, 20 May 2010 14:29:13 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Vladimir Pantelic <pan@nt.tu-darmstadt.de>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "ext Rafael J. Wysocki" <rjw@sisk.pl>,
       ext James Bottomley <James.Bottomley@suse.de>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100520112913.GA12055@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1274115885.4418.59.camel@mulgrave.site>
 <1274191188.10304.5.camel@mulgrave.site>
 <20100519065934.GH12879@nokia.com>
 <201005192242.55706.rjw@sisk.pl>
 <20100520044926.GB6773@nokia.com>
 <4BF51C9D.8050406@nt.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4BF51C9D.8050406@nt.tu-darmstadt.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 May 2010 11:31:26.0337 (UTC) FILETIME=[FBA1E710:01CAF80F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 01:27:25PM +0200, ext Vladimir Pantelic wrote:
>Felipe Balbi wrote:
>> Hi,
>>
>> On Wed, May 19, 2010 at 10:42:55PM +0200, ext Rafael J. Wysocki wrote:
>>>Please note that this approach is not too practical for vendors who ship
>>>systems like cell phones to the general public.
>>
>> yeah, tell me about it :-p
>>
>> during development on MeeGo devices we try to tackle down as much as
>> possible the use_time offenders and start by filing bugs to those apps,
>> instead of fixing their issues in kernel space.
>
>And you will continue doing that once the Meego app store has 100k apps?

I'm not here speaking for MeeGo. I'm presenting my own feelings and my 
own opinion regarding this issue. Don't bring the company into the game, 
please.

-- 
balbi

DefectiveByDesign.org
