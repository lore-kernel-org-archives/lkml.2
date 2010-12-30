Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0L3Ajs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:39:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0L3Ajr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CB+A0ZFHzB7mmx2S66lGfovQGdX0ABvnJ1lJPcD/q0N9cVyn/BjC6CqXCbLT/viOY3
         BMVRL8ihSU852HR6DkRQ==
Date: Wed, 29 Dec 2010 16:39:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node
 memory
In-Reply-To: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933D1.9020609@kernel.org> <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1639487692-1293669583=:6040"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1639487692-1293669583=:6040
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 29 Dec 2010, Yinghai Lu wrote:

> >> -v2: update it to recent numa-emulation change
> >>
> >
> > Lovely, yet another interbranch conflict.  This makes me very concerned.
> >
> > What is the delta between these?
> >
> 
> your new x86/numa have
> 
>        setup_physnodes(addr, max_addr, acpi, amd);
>        fake_physnodes(acpi, amd, num_nodes);
> 
> instead of
> 
>         acpi_fake_nodes(nodes, num_nodes);
> 
> in  numa_emulation()
> 

That's from f51bf3073a1 (x86, numa: Fake apicid and pxm mappings for NUMA 
emulation) and c1c3443c9c (x86, numa: Fake node-to-cpumask for NUMA 
emulation) in x86/numa.  Given the subject line, I think your patchset is 
targeted to the same branch so I'm not sure what's concerning?
--531368966-1639487692-1293669583=:6040--
