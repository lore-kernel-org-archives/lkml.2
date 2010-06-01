Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0FAOcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:32:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab0FAOcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=TRnVm0d9y3L7wGPmsckAWzYSf9GismUPL51yKRQ9BuWt9aVBMRgZsvKKh0oJT/uwwG
         q5EDq4bi+bQRIfdaMlyoZZO3hDlxlMP6Wk3EKmSZudHox/Ltgyi8YINuwhB9o0ieHLWB
         QbeLRhCMgG7SsupgCZp82QtsnGIjV5g1Tdza4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: sedat.dilek@gmail.com
Subject: Re: [FIXED] 2.6.35-rc1: Call trace: BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/2344 (cpufreq-releated?)
Date: Tue, 1 Jun 2010 16:31:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       markgross <mgross@linux.intel.com>, dmonakhov@openvz.org
References: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com> <AANLkTimj_kruEyL3Ac7xJZt0tunTua6JDBcuAU7XbWoP@mail.gmail.com> <AANLkTinVrUPdaRtLIU4ZfNprJY5SVRmFDIjvOmeAzqOC@mail.gmail.com>
In-Reply-To: <AANLkTinVrUPdaRtLIU4ZfNprJY5SVRmFDIjvOmeAzqOC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006011631.53084.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 31 maja 2010 o 10:10:51 Sedat Dilek wrote:
> [ Removed CC to "Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>"
> (email-adsress seems not to exist) ]
> 
> Indeed, the patch fixes the cpufreq issue here - Thanks.
> 
> Feel free to add:
> 
>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> 
> - Sedat -

This patch (thanks Sedat for information) also helps me:
http://marc.info/?l=linux-kernel&m=127533824131117&w=2

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
