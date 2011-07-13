Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab1GMEq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 00:46:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3951 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1GMEqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 00:46:25 -0400
Subject: Re: [PATCH] RESEND ibmmca: trivial typo fixes
From: Joe Perches <joe@perches.com>
To: dave@gnu.org
Cc: trivial <trivial@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Michael Lang <langa2@kph.uni-mainz.de>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1310530933.4444.8.camel@offbook>
References: <1310530933.4444.8.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:46:24 -0700
Message-ID: <1310532384.1662.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 00:22 -0400, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
[]
> @@ -487,7 +487,7 @@
>     1) Submitting the extra-array ldn_is_tape[] -> to the local ld[]
>        device-array. 
>     2) CD-ROM Audio-Play seems to work now.
> -   3) When using DDS-2 (120M) DAT-Tapes, mtst shows still density-code
> +   3) When using DDS-2 (120M) DAT-Tapes, must show still density-code

I think the original is correct.
mtst is a utility.

