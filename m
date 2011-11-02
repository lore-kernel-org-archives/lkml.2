Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1KBAY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 20:24:59 -0400
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:33876 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755969Ab1KBAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 20:24:58 -0400
X-Yahoo-Newman-Id: 125477.25656.bm@smtp211.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7W9m5s4VM1lN.rhHQQb3RH.MRehaEndpzPb23mGlabY_eKR
 tZEtw0RuiX027WhQtBQk9PJ2TysVQpaEYJByHkljgz6VT4bsAIG8Bm9.NSto
 1j6xwByjvzdtoumdAWOVcxbR9RRgzMlL7bcQVoGZDtE4fvQrQPDjHLZAvurv
 e307sRw90kD9ioZMZZqy.raR0EofxzukHUY4oGbtCnJHdOkmaOD6HhGzGOwp
 W7c3n3EBzbsNrHKoTMGPLPSa9TYvHMFyIDJNzs3oGC7nLl67vUYd9cJiD4ol
 khsHBHLe3obDi_Hy4svyFHn5_mUgYuFm5bt8mevuFTCJPfp0dzoCwZtKLURC
 nfvhX34diazxHYnqkp3h6C76STgDN9L4S7zu5fZNbplJDuB4wwHnIZZFQNOd
 xWTzfH1myJWdVjuGwzq57c6a9G94yZgQno6s3NC1y
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 1 Nov 2011 19:24:44 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        dmitry.torokhov@gmail.com
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102002442.GA4793@zeus>
References: <20111101124759.GA1326@zeus>
 <20111101164235.GS18855@google.com>
 <20111101191459.GA2748@zeus>
 <20111101201902.GA1763@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101201902.GA1763@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 01:19:02PM -0700, Tejun Heo wrote:
> 
> Odd... how about the following one?  Thanks.
> 

No, the 2nd patch doesn't work either. However, as I mentioned, reversing 
8ee294cd9def000 (and part of 1d64b655dc083df) does fix it.

~ Andy

PS I noticed your posts make it to linux-pm@lists.linux-foundation.org.
   Mine never arrive there. Is that list closed?

