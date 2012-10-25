Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330Ab2JYVIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:08:51 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36784 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760257Ab2JYVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:08:49 -0400
Date: Thu, 25 Oct 2012 14:08:49 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        George Zhang <georgezhang@vmware.com>
Message-ID: <723255296.2652440.1351199329247.JavaMail.root@vmware.com>
In-Reply-To: <20121025203148.GA28096@kroah.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC22 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> You can't just say "general GPL issues aside".  Honestly, given your
> company's prior actions in regards to Linux kernel drivers and the
> licenses of them, I don't trust them at all.  To help gain that trust
> back, marking the exports in this manner will be a great improvement.
> 
> To insist otherwise is to only reinforce my doubts, and reduce my
> wanting to even review or accept this code at all.  Sorry about that.

That's perfectly fair.  In the interest of gaining back some of that
trust, we'll be more than happy to make the exports GPL.  Expect a diff
in the next few days with that change along with any modifications
necessary after a sparse sanity check.

Thanks!
- Andy

PS I finally remembered to drop vm-crosstalk, so hopefully you won't
get anymore annoying bounces.
