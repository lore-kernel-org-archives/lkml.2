Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2GFRW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:22:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53623 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2GFRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:22:22 -0400
Message-ID: <4FF71E93.9000104@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2012 10:21:23 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: preeti <preeti@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-acpi@vger.kernel.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH V2] Suspend,cpuidle:resume_hang fix with cpuidle
References: <4FEC20D2.2070501@linux.vnet.ibm.com> <4FF6566B.8020409@linux.vnet.ibm.com> <4FF696D4.4040905@linux.vnet.ibm.com> <201207061923.29748.rjw@sisk.pl>
In-Reply-To: <201207061923.29748.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070617-2398-0000-0000-0000083A0782
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 10:23 AM, Rafael J. Wysocki wrote:
> OK, this looks good to me.  Queuing up in the linux-next branch of the
> linux-pm.git tree.  If no problems with it are reported, I'll move it to the
> pm-cpuidle branch in a couple of days.

I've got this running on the problem hardware.  It seems to be OK, at
least initially, so feel free to add my Tested-by.

