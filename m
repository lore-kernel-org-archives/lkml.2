Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0FPNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:16:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52100 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0FPNQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fEP0ln+se0O/Dng1ay2RxOuobNjAjA010hA1GqknkgQ7z+oD9uFE42uvzZHWCT4KM/
         EEcHLzfqI+ydqSkBVuKpohza7u6Se/ENFRqg+ptMMGFWBeCCeSJNsa1PA7mUQslKnvmi
         K0mGWv+Kd4YIpdCAQ3T6/vUNFkMn3wRxcbyys=
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100616125708.GA1893@jolsa.lab.eng.brq.redhat.com>
References: <1276691043-12694-1-git-send-email-jolsa@redhat.com>
	 <1276692314.2632.66.camel@edumazet-laptop>
	 <20100616125708.GA1893@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 15:10:37 +0200
Message-ID: <1276693837.2632.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 juin 2010 à 14:57 +0200, Jiri Olsa a écrit :
> On Wed, Jun 16, 2010 at 02:45:14PM +0200, Eric Dumazet wrote:

> > I respectfully suggest that every patch adding a synchronize_rcu() call
> > be reviewed by Paul himself. This is really the last option that should
> > be considered, since it adds a big delay.
> 
> no problem, I wasn't aware of this
> 
> > 
> > Can you explain why other solutions cannot be used ?
> 
> I'm not sure which ones do you mean.. I'm not RCU expert, and
> this one occured to me as probable fix, but if there're other
> ways, no problem ;)

To be fair, I am not RCU expert either, since I make mistakes on each
RCU related patch I post. Welcome to the club :)


