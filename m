Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1EBHJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 03:09:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47413 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab1EBHJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 03:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OeI7gDWrYhRoivQBg9oOXSqdTSTc8WZvHETRZXFwq4o5kiXkyWS82Io0Rw8Dwn3NiU
         ch8X1WbNq+z8z6iyQfNlZ6/iFQz2JXKUtd/pagVY21MRdp/MLt4948A3UB+Pl3jNIk8G
         L8iPqkHJhnfbUhBzGY028C2e4Y1csRFM74/OA=
Message-ID: <4DBE589C.1040103@gmail.com>
Date: Mon, 02 May 2011 11:09:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
References: <20110430171459.685415696@openvz.org>	<4DBC6DC1.30900@redhat.com>	<20110501164635.GA21833@elte.hu>	<BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>	<20110502053928.GB18376@redhat.com> <BANLkTi=Bw5k1_oytZmXgTrQ-XUJisp3vfQ@mail.gmail.com>
In-Reply-To: <BANLkTi=Bw5k1_oytZmXgTrQ-XUJisp3vfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 09:51 AM, Cyrill Gorcunov wrote:
> Yeah, i'll do so as only bring my laptop to life, I managed to kill
> grub and can't restore it back for a while, will ping you back as soon
> as I can.
> 
> Sorry for top post.
> 

  I've managed to semi-restore it. Gleb, maybe there some additional
parameter needed for kvm (except -cpu host,+x2apic) to make it work
with cluster mode? I always see physical mode which was not the target
of the patch series.

-- 
Thanks,
  Cyrill
