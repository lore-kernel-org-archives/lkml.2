Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2FRVJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:09:06 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:34087 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2FRVJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:09:05 -0400
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <1339979586.1666.13.camel@shrek.rexursive.com> <20120618123205.GA5319@x1.osrc.amd.com> <201206182229.32055.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201206182229.32055.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Tue, 19 Jun 2012 07:08:51 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>So, I think printing a status line every 10% would be fine.

My patch prints a dot every 10%, which is not on a separate line. Did you want me print a full line instead or are you saying dots are fine?

PS. Yeah, the current printout with \b is a hack and I do not particularly like it either. Proper way would be with plymouth or something like that, but I got no joy with that on that list. One day, maybe...

-- 
Bojan
