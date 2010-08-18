Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0HRRw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:52:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0HRRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:52:25 -0400
Message-ID: <4C6C1DE3.5000403@vlnb.net>
Date: Wed, 18 Aug 2010 21:52:35 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: landman@scalableinformatics.com
CC: James Bottomley <James.Bottomley@suse.de>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <1282144271.3035.31.camel@mulgrave.site> <4C6C0A30.1070008@scalableinformatics.com>
In-Reply-To: <4C6C0A30.1070008@scalableinformatics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:KX7EB/+PS118sudWRdiIjDcKk/nVVE0379zzxNouufe
 uD1uf7nnhy898Yp18QBThcEDW48jwiMzdC/hVM4KKMjUnk9n4N
 rwQWJDsKC2rYs5YPHJzCG64/eQe0z7rFRJeDK6dMPyjnwpU602
 BvvG8Nqacqm530+JQ8PO2ifLJ75u09gFI14hSCT6V/wNbqRSCX
 ZTPlSkHxQ10db3SnCw8QA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Landman, on 08/18/2010 08:28 PM wrote:
> Quick question ... will LIO support SRP?  I should probably run over to
> their lists and ask, but a quick inspection of their site this morning
> shows that they are mostly iSCSI and FC focused.  (LIO folks, please
> feel free to step up and comment)
>
> I'd certainly like to see a single framework, but not at the cost of
> losing important (to us) functionality.  We'd like to continue to use
> SRP, and iSCSI.  We'd like to use iSER (which is in the tgt stack) which
> LIO would give us when merged with tgt.  We are currently using SCST's
> iSCSI and SRP stack within our products.

Joe,

For iSER LIO would not give you anything SCST can't give you. With LIO 
you would use the iSER target via STGT pass-through sg/bsg. You can the 
same way use it with SCST scst_local module.

Vlad
