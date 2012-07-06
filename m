Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2GFRZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:25:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab2GFRZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:25:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] Suspend,cpuidle:resume_hang fix with cpuidle
Date: Fri, 6 Jul 2012 19:30:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: preeti <preeti@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-acpi@vger.kernel.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <4FEC20D2.2070501@linux.vnet.ibm.com> <201207061923.29748.rjw@sisk.pl> <4FF71E93.9000104@linux.vnet.ibm.com>
In-Reply-To: <4FF71E93.9000104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207061930.50334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 06, 2012, Dave Hansen wrote:
> On 07/06/2012 10:23 AM, Rafael J. Wysocki wrote:
> > OK, this looks good to me.  Queuing up in the linux-next branch of the
> > linux-pm.git tree.  If no problems with it are reported, I'll move it to the
> > pm-cpuidle branch in a couple of days.
> 
> I've got this running on the problem hardware.  It seems to be OK, at
> least initially, so feel free to add my Tested-by.

OK, thanks!
