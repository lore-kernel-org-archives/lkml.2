Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0DTTiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:38:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:34517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0DTTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=pwZB+e6HDPmj4XkQnI63K4LjzIZ3m4VOpyLPf3qMdZxI6COWkFf540LEEfDzarAImi
         ABznas4675whA2VD8bOqvwn7J8QkoCANVjxh7Ey1c/k3dHx9zGdUor4z6iYVMRN8xznx
         8VPoq1glqDJh9O1ZplKSHzLCmMLWNL9aiXWqM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15659] [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Date: Tue, 20 Apr 2010 21:33:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4; KDE/4.3.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.zz.KSSzLB@tosh>
In-Reply-To: <YeFfFNFyTSF.A.zz.KSSzLB@tosh>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004202133.00708.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 20 kwietnia 2010 o 05:19:20 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the
>  tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15659
> Subject		: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR*
>  Hangcheck timer elapsed... GPU hung Submitter	: Maciej Rutecki
>  <maciej.rutecki@gmail.com>
> Date		: 2010-03-25 20:04 (26 days old)
> Message-ID	: <201003252104.24965.maciej.rutecki@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=126954749618319&w=2
> 

Bug still exists in 2.6.34-rc4
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
