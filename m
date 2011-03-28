Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1C1Whc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:37:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1C1Wha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pDd8MGFoLZm/ODjdTBi97tYd0/cvtCCmks42LT8epssLxoToV6vXTA/lqw4q9c8OHu
         MhxaZBSsVzfdv4BLKncA==
Date: Mon, 28 Mar 2011 15:37:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #30572] 2.6.38-rc7, OOM behaviour?
In-Reply-To: <40UNry85rJN.A.clE.1n5jNB@chimera>
Message-ID: <alpine.DEB.2.00.1103281535130.7148@chino.kir.corp.google.com>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <40UNry85rJN.A.clE.1n5jNB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1846350481-1301351845=:7148"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1846350481-1301351845=:7148
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 27 Mar 2011, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30572
> Subject		: 2.6.38-rc7, OOM behaviour?
> Submitter	: Mathias Burén <mathias.buren@gmail.com>
> Date		: 2011-03-02 19:33 (26 days old)
> Message-ID	: <AANLkTine5sru_JsK1LmRVa9fwxjPsaDdZUTFPCBi6A+c@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=129909440018096&w=2
> 

The log that was presented in the References link is a normal oom killer 
log and would be typical if you exhausted 1GB of swap space.  It correctly 
kills the chrome process in the log provided, but other relevant portions 
seem to have been snipped for futher diagnosis.

Mathias, could you please provide the entire oom killer output, 
specifically the last time it was invoked (search for "invoked 
oom\-killer" and paste everything after the last occurrence)?
--531368966-1846350481-1301351845=:7148--
