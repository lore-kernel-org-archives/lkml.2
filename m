Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab1CXSvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:51:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab1CXSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qJcm5FLviliuCQOIcTLHPa1t+MhpqcgnP2U3JxH7NMqakhrp2Q+4ogYPIyxThsHWKy
         z2DYhvgAtdecBOd/S1X2vIK/PvT6DjKoyEWTkXfzTz9mEIQqEMv7sg9NBNWoaa4tsGDH
         +9E01375Xj2hSTSDqN7N/XWl9/oHzP+ZpVqHk=
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1103241346060.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	 <20110324142146.GA11682@elte.hu>
	 <alpine.DEB.2.00.1103240940570.32226@router.home>
	 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	 <20110324172653.GA28507@elte.hu>
	 <alpine.DEB.2.00.1103241242450.32226@router.home>
	 <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	 <alpine.DEB.2.00.1103241300420.32226@router.home>
	 <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	 <alpine.DEB.2.00.1103241312280.32226@router.home>
	 <1300990853.3747.189.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103241346060.32226@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 19:51:48 +0100
Message-ID: <1300992708.3747.211.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 13:47 -0500, Christoph Lameter a écrit :

> Hmmm.. Could be. KVM would not really disable interrupts so this may
> explain that the test case works here.
> 
> Simple fix would be to do a load before the cli I guess.
> 

Hmm... 

If we have a preemption and migration right after this load...



