Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0CORni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:43:38 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:39089 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0CORng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:43:36 -0400
X-SENDER-IP: [83.226.250.22]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AitBAIMOnktT4voWPGdsb2JhbACBPYFPgl6Bd5McAQEBATeqSY9IgTKCX2oE
X-IronPort-AV: E=Sophos;i="4.49,644,1262559600"; 
   d="scan'208";a="50679736"
Message-ID: <4B9E71C8.2000201@coyote.org>
Date: Mon, 15 Mar 2010 18:43:36 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: winbond: mac_structures.h Fixed indentation,
 whitespace etc
References: <1268674719-9544-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268674719-9544-1-git-send-email-lindley@coyote.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops..Should only be one patch..resent it..
Forget this one.

/Lars

On 2010-03-15 18:38, Lars Lindley wrote:
> I fixed all problems reported by checkpatch.pl except typedefs.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/mac_structures.h | 1066 +++++++++++++++---------------
>  1 files changed, 522 insertions(+), 544 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
> index 0d16196..ebef821 100644
blabla...
