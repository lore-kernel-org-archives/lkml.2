Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0ETL33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:29:29 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:33380 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0ETL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:29:27 -0400
X-RZG-AUTH: :OmAFcUmlcu0bbsYlAMGuT81N1ZtviIu951RQ8yFYTS/HRx5C62C/ggokmk+RVNRiaLVW
X-RZG-CLASS-ID: mo05
Message-ID: <4BF51C9D.8050406@nt.tu-darmstadt.de>
Date: Thu, 20 May 2010 13:27:25 +0200
From: Vladimir Pantelic <pan@nt.tu-darmstadt.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
To: felipe.balbi@nokia.com
CC: "ext Rafael J. Wysocki" <rjw@sisk.pl>,
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
References: <1274115885.4418.59.camel@mulgrave.site> <1274191188.10304.5.camel@mulgrave.site> <20100519065934.GH12879@nokia.com> <201005192242.55706.rjw@sisk.pl> <20100520044926.GB6773@nokia.com>
In-Reply-To: <20100520044926.GB6773@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> Hi,
>
> On Wed, May 19, 2010 at 10:42:55PM +0200, ext Rafael J. Wysocki wrote:
>>Please note that this approach is not too practical for vendors who ship
>>systems like cell phones to the general public.
>
> yeah, tell me about it :-p
>
> during development on MeeGo devices we try to tackle down as much as
> possible the use_time offenders and start by filing bugs to those apps,
> instead of fixing their issues in kernel space.

And you will continue doing that once the Meego app store has 100k apps?
