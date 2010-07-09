Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0GIXax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:30:53 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:25631 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753579Ab0GIXav convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:30:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 65634.62358.bm@omp204.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WSHuY0u4vH/FurBnIYGfB2E+SaAZGreJ44cUVfvVRvCd+Cqlb60iZsnVcnq09IRAc2qP7L+32c4PTAcjOjCcrLUMVPceyWy0VvNWoL6sEDPeNRbUBhVzsZSuhGA0KGkQBGyMinFOcMXcGQDz3xixLTFKP+LhDGykh0fkYkXOZuU=;
Message-ID: <855377.6648.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: wi52FA4VM1k._nNjIuYZePwQdtiam0mYEsSXOP3dHi0CJTO
 UJ16B.zNyezAB59xnlGsqK_61tRoOOHhKd7KzcC4aIHqLUVSpsQsQt8Y1KQz
 NSV4QULe9N0eiJeFtwGarRMIi.A8dPstZljVlVO64X0TzQkC1b5OrpjhT.L3
 SXM0Nz16jhXbN9ss6A2jHlAmHpLzMl0AW8ovkV2aG7T3U.LmMvCjQxcwjsqm
 IbP5ZhrZu65VECx7A8jtd8YOq2GyG2v21BVC4tuLzsbsRSTqS16K0mqXMWRn
 IsT4_lJT.CM9SOGs4
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.274457
Date: Fri, 9 Jul 2010 16:30:50 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/2] gpiolib: get rid of struct poll_desc and worklet
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
In-Reply-To: <1278703458-26412-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like patchees like this, which remove code
and simplify stuff.

Given some tested-by confirmations, I'd be
biased towards accepting this.  But for now
I'm not in a position to say more; sorry.


