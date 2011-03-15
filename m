Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1COXw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:52:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:10037 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1COXw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:52:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,191,1299484800"; 
   d="scan'208";a="403180049"
Subject: Re: [PATCH 05/13] scsi: use list_move() instead of
 list_del()/list_add() combination
From: Robert Love <robert.w.love@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
In-Reply-To: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
	 <1300229605-14499-5-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 16:52:25 -0700
Message-ID: <1300233145.19083.383.camel@fritz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 15:53 -0700, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Robert Love <robert.w.love@intel.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: devel@open-fcoe.org
> ---
>  drivers/scsi/esp_scsi.c     |    6 ++----
>  drivers/scsi/fcoe/libfcoe.c |    6 ++----

Hi Kirill,

   libfcoe.c doesn't exist anymore in the scsi-misc tree with recent
fcoe transport changes. Specifically, the change you're trying to make
should be to fcoe_ctlr.c.

   I'll resend an updated patch that applies to scsi-misc and has my
Ack.

Thanks, //Rob

