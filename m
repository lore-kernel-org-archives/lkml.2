Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0J1FSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 01:18:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49301 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0J1FSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 01:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ECQGfMTH+ZocLj+jwaXngQlb8+DWdhUozbU1rluVJDFYVgGo16oSPdNzglmmxJSA/O
         g7+Rdq0yHbNYw9FqY/Q9GdiVSvlNQJjXAn/U1Pgw5tIuKJzKszri5G+SZYn1VNKoeJkr
         8erSkQ9rXmtW7/Eh5B9M2T5IW9E0riXcja4/0=
Subject: Re: [PATCH] cxgb3: fix crash due to manipulating queues before
 registration
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: sonnyrao@us.ibm.com, Divy Le Ray <divy@chelsio.com>,
        Dimitris Michailidis <dm@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288242390-28574-1-git-send-email-nacc@us.ibm.com>
References: <1288236563.2658.59.camel@edumazet-laptop>
	 <1288242390-28574-1-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 07:18:30 +0200
Message-ID: <1288243110.2658.126.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 22:06 -0700, Nishanth Aravamudan a écrit :
> Hi Eric,
> 
> Something like the following?:
> 
> Thanks,
> Nish

Yes, probably, but I dont have the hardware so cannot test.


