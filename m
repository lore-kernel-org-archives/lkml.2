Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0FWUhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:37:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46690 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0FWUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VYdUMhHqrKhEjbyE6GAKDfMKIuQYjGJ3PDhHHXABG3kYcf8A1+lwwajSDgzG5Ra2VW
         NMEN1KYYFtrFsxW6JnWwj1kL2R3IuDRSax+ByAOwiSon7TykvOV6MZEIhY9NFw2rmSCJ
         1YsKxgMqaLjPJco8E0USCrm7QkTsAXf9kjjRs=
Message-ID: <4C22706E.9020005@garzik.org>
Date: Wed, 23 Jun 2010 16:37:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>, Luming Yu <luming.yu@gmail.com>
Subject: Re: [Bug #16172] 2.6.25-rc1 ahci regression
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.6TG.fNpHMB@chimera>
In-Reply-To: <W8JfMs9cZw.A.6TG.fNpHMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 06:17 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16172
> Subject		: 2.6.25-rc1 ahci regression
> Submitter	: Luming Yu<luming.yu@gmail.com>
> Date		: 2010-06-03 7:02 (18 days old)
> First-Bad-Commit: http://git.kernel.org/linus/365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
> Message-ID	:<AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>>
> References	: http://marc.info/?l=linux-kernel&m=127554855724361&w=2

As noted in the bug, this is IMO a problem of certain userlands not 
properly digesting module dependencies...


