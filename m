Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab1EBPBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:01:51 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:54755 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772Ab1EBPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:01:49 -0400
Date: Mon, 2 May 2011 17:01:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Robert Richter <robert.richter@amd.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        oprofile-list@lists.sf.net, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] s390: oprofile: fix error checks in
 oprofile_hwsampler_init()
Message-ID: <20110502170141.0db73ad9@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20110502154805.71664123@absol.kitzblitz>
References: <20110502154805.71664123@absol.kitzblitz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011 15:48:05 +0200
Nicolas Kaiser <nikai@nikai.net> wrote:

> Checking 'oprofile_min_interval < 0' and
> 'oprofile_max_interval < 0' doesn't work because
> 'oprofile_min_interval' and 'oprofile_max_interval' are unsigned.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Makes sense, I'll queue it up. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

