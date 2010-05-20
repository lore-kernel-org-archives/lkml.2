Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0ETQau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:30:50 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:30146 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751385Ab0ETQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:30:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 246322.63922.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=khRYmKtUUFCe2h1ts7Z05Z9yS9Ibl1PU5aRo295gATZHEWhHFDmvSTHiRzKHwWXbExcN5yQimiaLvtza1vC9A53Di56RBQ/+BVsgVs5EzBlTyxNf8MIV2YvNKzFu+iGyMfV1kE2Puonk14nm88m2HbR3miyhCTgHOtBv6VDRlS8=;
Message-ID: <128576.2944.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: aeNpfjYVM1lRrQSBVrpDq.n.htHmkdeMTalVopMHO0pwUT_
 5Nlm1yBeOP1CrlRol_sp5.MDvHT8.f6OWiyPHC4lOYu5nZKdswNMducZWFJm
 SSVL5pzI9VdU3A3nu5S_wVVZ7fP9jMzAFYsyC.7Zz9EOZIZz_EALLIBGrdge
 FIN0_B_7W5krFyt1q9iuddHttqQzedF7cjHxzcz285ENC7CbT5ncukTrgbfG
 hmAFpKpqXM7i.5AhKUZpDAhzZ6T.MLEkTXfBXkvMsrwa4m2h_YU2xSwPAm90
 ogwIJm40VVAOgvUNjdw--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 20 May 2010 09:30:47 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 7/8] USB: gadget: g_multi: more configurable
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <2460ac80ee51e759c7d4d552112c2e816db7c83b.1274187425.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Added Kconfig options for each
> function used by g_multi so that
> one can customize the gadget to a greater extend.

Note that g_multi was intended to be a a fairly simple example,
so another reason I don't like seeing all those config options
is that it would no longer be a simple example ....

I see you did a bunch of good work on MS-Windows interop (yay!),
but that can be done without complexifying this driver.  Let some
other (new) driver take that role of "complex example"), but keep
the simple one so there's an easy approach to the easy concepts.

