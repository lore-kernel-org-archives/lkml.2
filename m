Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2ECL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:27:47 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:57235 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2ECL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:27:46 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Thu, 3 May 2012 14:27:52 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-41-generic; KDE/4.4.5; i686; ; )
Cc: alan@lxorguk.ukuu.org.uk,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, ido@wizery.com
References: <201204241429.05526.vlad@scalemp.com>
In-Reply-To: <201204241429.05526.vlad@scalemp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031427.52736.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 24, 2012 02:29:04 pm Vlad Zolotarov wrote:
> Alan, pls., consider applying the following patch series.
> 
> The idea is to move x86_cpu_to_apicid to the __read_mostly section
> in order to avoid false sharing on large multiprocessing systems.

Thomas, Ingo, Peter, the same here - should I respin this patch series?

Pls., advice.

thanks,
vlad

> 
> thanks,
> vlad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
