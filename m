Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2LSWXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:23:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2LSWXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:23:34 -0500
Message-ID: <50D23E5E.4030403@redhat.com>
Date: Wed, 19 Dec 2012 23:23:26 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: Re: [PATCH] dm-crypt: never use write same (was Re: [v3.7 Regression]
 [SCSI] sd: Implement support for WRITE SAME)
References: <50CB8C74.3090102@canonical.com> <yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com> <yq1bodq7zdv.fsf@sermon.lab.mkp.net> <20121219195801.GA14456@redhat.com> <50D22766.9090107@redhat.com> <50D22C7F.2020201@redhat.com> <50D23DA3.9060104@canonical.com>
In-Reply-To: <50D23DA3.9060104@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 11:20 PM, Joseph Salisbury wrote:
> Great work, Milan.  Your patch fixes the bug, stops the panic and allows 
> dm-crypt to function properly.

Thanks.

> 
> Will you be requesting this in v3.8 ?

This should go into 3.7 stable as well, I am talking with Alasdair already
how to handle it.

Milan

