Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289Ab0EZHJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:09:53 -0400
Received: from crca.org.au ([74.207.252.120]:40958 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933987Ab0EZHJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:09:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFCC939.1000901@crca.org.au>
Date: Wed, 26 May 2010 17:09:45 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 0/5] Preallocate swap + minor fix.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

In current in-kernel hibernation code, swap is allocated as the image is 
being written.

The first four patches in this series rework things so that all swap 
that will be used is allocated prior to any data being written to disk.
The fourth patch might look like too much for one patch, but it's 
necessary to not break bisecting.

The fifth patch fixes a minor error in displaying the speed at which I/O 
occurred.

This is the beginning of what I hope will be a long series of sets of 
patches, first working towards adding support for properly asynchronous 
I/O (not batching, as is currently done), then compression, multiple 
swap devices and more. In short, this is the beginning of work on 
merging TuxOnIce functionality a bit at a time.

The work is coming now because I recently finished my previous job, so 
I'm seeking to get some of those jobs I've been wanting to do for a long 
time out of the way. If anyone wants to employ me to do this work, I 
wouldn't say no! :)

Please excuse me if there are wrapping issues with the patches - I'm 
using Thunderbird, and haven't sent a patch series for quite a while, so 
don't remember the fancy git mailer way (will have to look it up).

Rafael, these and future patches will be available at:

git://git.kernel.org/pub/scm/linux/kernel/git/nigelc/tuxonice-head.git#for-rafael

Regards,

Nigel
