Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1DARjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:39:05 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:46837 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1DARjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:39:03 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 13:39:03 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.44
Message-ID: <4D960BAA.3020700@iki.fi>
Date: Fri, 01 Apr 2011 20:30:18 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101214 Mandriva/3.1.7-1mdv2011.0 (2011.0) Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andrea Gelmini <andrea.gelmini@gmail.com>, linux-acpi@vger.kernel.org,
        axel.lin@gmail.com, trenn@suse.de, len.brown@intel.com,
        error27@gmail.com, malattia@linux.it, linux-kernel@vger.kernel.org
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com> <20110401172241.GA26851@srcf.ucam.org>
In-Reply-To: <20110401172241.GA26851@srcf.ucam.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.04.2011 20:22, Matthew Garrett wrote:
> On Fri, Apr 01, 2011 at 07:16:43PM +0200, Andrea Gelmini wrote:
> 
>> Git bisect blames this commit:
> 
> Pretty convinced that git bisect's got that wrong, given that it doesn't 
> touch any Sony code. I'll take a look at the Sony patches, thanks for 
> the report!

The same issue was posted yesterday on platform-driver-x86@ as "NULL
pointer dereference in sony-laptop" by Alessandro Guido, with a
preliminary patch from Mattia Dongili:

http://thread.gmane.org/gmane.linux.drivers.platform.x86.devel/1720

-- 
Anssi Hannula
