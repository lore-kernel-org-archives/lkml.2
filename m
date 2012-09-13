Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2IMWVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:21:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab2IMWVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:21:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are found
Date: Fri, 14 Sep 2012 00:27:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lwe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Lin Ming <minggr@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com> <201209132317.32969.rjw@sisk.pl> <20120913221047.GA4598@aftab.osrc.amd.com>
In-Reply-To: <20120913221047.GA4598@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140027.34079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 14, 2012, Borislav Petkov wrote:
> On Thu, Sep 13, 2012 at 11:17:32PM +0200, Rafael J. Wysocki wrote:
> > I'll take it. There are two more ACPI PM patches that would be good to
> > have in v3.6 IMO.
> 
> Ok, cool. Can you pls adjust the stable tag to include 3.4 too?

I'll just use <stable@vger.kernel.org> I think.

Thanks,
Rafael
