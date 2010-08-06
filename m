Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934509Ab0HFNXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:23:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42582 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab0HFNXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B+zFgbcpxLDRs4CRtKYHV3pl77+3B7ZJzCFKVt20mq16HbAzgoRQzBICvXmUOSGrG2
         62sZDDOT1i0tjSP9viW0R0wF+Skr0uycoPIvwsSDpxttZy24bNrm+UO0fAN2lgAeD6gm
         rxp52xdw4B37IGUIxearQoWsSsC6gOL3UDeOc=
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4C5C06A6.7070206@kernel.org>
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
	 <4C5C04D8.1080103@kernel.org> <1281099197.1655.11.camel@leonhard>
	 <4C5C06A6.7070206@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 22:23:34 +0900
Message-ID: <1281101014.1655.20.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-06 (금), 14:57 +0200, Tejun Heo:

> Ah, I see.  Then, the right thing to do is to add proper checking and
> markups to UP accessors matching the SMP ones.
> ie. __verify_pcpu_ptr() verification followed by __kernel __force
> casting.  Are you interested in doing it?
> 
> Thanks.
> 

Sure. :-)
Although I'm not sure that it is really needed, if so I'll do that.

-- 
Regards,
Namhyung Kim


