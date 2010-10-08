Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0JHMlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:41:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:59914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0JHMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:41:00 -0400
Message-ID: <4CAF115A.7020909@kernel.org>
Date: Fri, 08 Oct 2010 14:40:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard>	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>	<4CAB5779.5020901@kernel.org>	<AANLkTineNfy+hfnK-sjHNB+h05oC4qbJ+81pg95Bmn=b@mail.gmail.com>	<4CAC366E.7070609@kernel.org>	<4CAC38D9.8020407@kernel.org>	<AANLkTikw=ObzgWu35fsuriC-jVrzDRHRfFJeT8-4-ndY@mail.gmail.com>	<4CAC934E.2030807@kernel.org>	<AANLkTinrBeMDyQJaYJFALTPpOgEaAy7yoPdyQ0Gpay3G@mail.gmail.com>	<4CACC0CD.5000001@kernel.org>	<4CADAB97.4020500@kernel.org>	<AANLkTikRZZMq9GkaCn_BB7H=F0iGj3P-XbiaEU3RoN5V@mail.gmail.com>	<4CADD3A3.5090401@kernel.org>	<AANLkTikRn9hUb6dgGBGvF8czRxqLxm8utXR+iEN17cs1@mail.gmail.com>	<4CADEA3D.3020800@kernel.org> <AANLkTi=LnbH7LNUr+YuR+uKLFasKyV7hOZc1zD0qqHnW@mail.gmail.com>
In-Reply-To: <AANLkTi=LnbH7LNUr+YuR+uKLFasKyV7hOZc1zD0qqHnW@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 12:41:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding back lkml)

I can now more or less reliably reproduce the hang.  I'll write when I
know more.

Thanks.

-- 
tejun
