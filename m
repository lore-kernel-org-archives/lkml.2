Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887Ab0GPPlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:41:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41062 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965821Ab0GPPlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:41:52 -0400
Message-ID: <4C407DBC.3060007@austin.ibm.com>
Date: Fri, 16 Jul 2010 10:41:48 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] De-couple sysfs memory directories from memory	sections
References: <4C3B3446.5090302@austin.ibm.com> <20100716071320.GC31612@kroah.com>
In-Reply-To: <20100716071320.GC31612@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 02:13 AM, Greg KH wrote:
> On Mon, Jul 12, 2010 at 10:27:02AM -0500, Nathan Fontenot wrote:
>> This set of patches de-couples the idea that there is a single
>> directory in sysfs for each memory section.
> 
> Any reason you didn't cc: the sysfs maintainer on these patches?  If
> not, I'll gladly ignore them...

Ummm.... I have no good excuse. :)

Will add you to cc for v3 of the patch.

> 
> (hint, scripts/get_maintainer.pl is your friend...)
Thanks.

-Nathan
> 
> greg k-h

