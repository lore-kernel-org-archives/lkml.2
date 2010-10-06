Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0JFKpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:45:23 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42014 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0JFKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:45:22 -0400
Message-ID: <4CAC5337.3090708@canonical.com>
Date: Wed, 06 Oct 2010 18:45:11 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
References: <20101005151126.eadae817.sfr@canb.auug.org.au>
In-Reply-To: <20101005151126.eadae817.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the inconvenient.

I update the patches and push to
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git for-upstream

Just test build and install on ideapad I have. It works fine.


On 10/05/2010 12:11 PM, Stephen Rothwell wrote:
> Hi Matthew,
> 
> After merging the drivers-x86 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> make[4]: *** No rule to make target `drivers/platform/x86/ideapad_laptop.c', needed by `drivers/platform/x86/ideapad_laptop.o'.  Stop.
> 
> Caused by commit 9efe5c1540a1e03cb2e0fca85e49fc4c57c6e771 ("ideapad:
> Change the driver name to ideapad-laptop").  The commit renames
> ideapad_acpi.c to ideapad-laptop.c but the Makefile uses ideapad_laptop.o
> (note underscore v. dash).
> 
> Presumably this was never even build tested :-(
> 
> I have used the drivers-x86 tree from next-20101004 for today.

