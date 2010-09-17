Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0IQPDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:03:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39164 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0IQPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sCW3jHU6zLNfonB1ezya74KzOhoGsmGCYyrH0RQJdwTj3Gs4FMekTqtAGukeXqo38s
         mpiwM/bE4v+iu0WWFQmNddOBWqcDLCCWYlxBOi4q4LkoesdA54X1MszVt8Gf1sQlPLIr
         QT72pywmr+ayZz7jYXCzkNB9Gr/XDelMcX6Zk=
Subject: Re: Regression, bisected: WARNING spam with ipsec since 2.6.35
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20100917141920.GA9280@elliptictech.com>
References: <20100916213138.GA6605@elliptictech.com>
	 <1284676070.4784.25.camel@edumazet-laptop>
	 <20100917141920.GA9280@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 17:03:30 +0200
Message-ID: <1284735810.3391.85.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 17 septembre 2010 à 10:19 -0400, Nick Bowler a écrit :
> On 2010-09-17 00:27 +0200, Eric Dumazet wrote:
> > I suspect following patch is needed, before further changes.
> > 
> > [PATCH] xfrm: dont assume rcu_read_lock in xfrm_output_one()
> 
> Yup, that makes the warnings go away.  Thanks.
> 

Thanks for testing.



