Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966349Ab2JZUIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:08:55 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:60314 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966288Ab2JZUIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:08:54 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2012 16:08:54 EDT
Date: Fri, 26 Oct 2012 13:02:53 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        George Zhang <georgezhang@vmware.com>
Message-ID: <1734741434.3740170.1351281773036.JavaMail.root@vmware.com>
In-Reply-To: <723255296.2652440.1351199329247.JavaMail.root@vmware.com>
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

> in the next few days with that change along with any modifications
> necessary after a sparse sanity check.

We have a change that fixes things, but I wanted to check if you
had any additional comments before we send out more patches.  In
all likelihood you'd probably already given up in disgust after
the vanilla exports, but I wanted to be sure :)

Also, would you prefer a complete refresh of the series or just
diffs?

Thanks!
- Andy
