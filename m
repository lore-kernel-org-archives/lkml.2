Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1KDOso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:48:44 -0400
Received: from thoth.sbs.de ([192.35.17.2]:22922 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1KDOsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:48:43 -0400
Message-ID: <4EB3FB16.2000003@siemens.com>
Date: Fri, 04 Nov 2011 15:47:50 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-04 09:38, Pekka Enberg wrote:
> Finally, I discovered one interesting (and esoteric) use case at LinuxCon
> Europe for the KVM tool:
> 
>   https://events.linuxfoundation.org/events/linuxcon-europe/sweeney
> 
> It turns out they use KVM tool in some parts of their simulation clusters
> because its startup memory footprint is much smaller than Qemu's.

That's mostly due to QEMU's internal guest memory represenation which
will be reworked in the near future (the large amount of device models
for all the QEMU target architectures had to be converted first).

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
