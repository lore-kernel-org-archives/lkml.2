Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0DTU1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:27:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43073 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0DTU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gYQUwlCjzYrqg0Plyf2BymM2MDqf1fqzKNF2QYlbJ+X5zwma+4nr4iE1O3M+L1ln/c
         HJxAqZTA7jAFpjr5JTIu9xgAfcPSL+DS5u3Xf0f+qcEW2rp6mmjuH4DIdH8xA1VUJmg+
         oLeYhy6nZodPJM/HXgcdEqDQb7s+lDk7Eybno=
Date: Tue, 20 Apr 2010 16:24:00 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug #15795] 2.6.34-rc4 : OOPS in unmap_vma
In-Reply-To: <YeFfFNFyTSF.A.GdG.KRSzLB@tosh>
Message-ID: <alpine.DEB.2.00.1004201623280.10496@parag-laptop>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.GdG.KRSzLB@tosh>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Apr 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15795
> Subject		: 2.6.34-rc4 : OOPS in unmap_vma
> Submitter	: Parag Warudkar <parag.lkml@gmail.com>
> Date		: 2010-04-14 (6 days old)
> Message-ID	: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
> References	: http://marc.info/?l=linux-kernel&m=127121006625429&w=2
> 
> 
> 

Hasn't reproduced after many retries and I am not sure it can be called a 
regression, may be it's always been there, just not reproducible easily - 
let's close this, I will reopen if needed.

Thanks,

Parag
