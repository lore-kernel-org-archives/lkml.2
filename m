Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0HCAAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:00:07 -0400
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:48087 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751460Ab0HCAAB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:00:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 20:00:01 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lPLvwLuvPD3EpSNOQ/O9ZzgSPtQuYq8VEWDSThKczWJ0+fkoZyIrSRCXUrbO84UXpBDoAoP7Ohn/cPumPjbRS6bBny9HkAUGWZMrDtgJygvRhSb5m/ADdJUSi86iUHjHtZu4v6qfe2IqTBehJQEzN79oNQYpyPNMmdLDy2foryA=;
Message-ID: <687001.43699.qm@web52902.mail.re2.yahoo.com>
X-YMail-OSG: 1RNtf6MVM1kz8kBwvxA4nuvBha_rnvyeqLo8faCHFnT642c
 9ATJDBbxuoTfE7KitbzHzytNnY2aXhRNTkyUOfhgrWAOekb..q9WzJv768LV
 ybv2daNA1__jbzcPX1aH59ARNu1xBpDjRc7L5wKeMG0GCodsa5z.6cHiW0Dp
 J5w438cSkYlSqTIbkLNzikDuEmF.GlX3Oj.ThYLxxaK3o9Xwd4MkHwygNBFX
 x_wlSTY4c8dt_RrX34npONzXHbcG_SGxquqd4VMdPfiQIr9CT2XZ_ckO765I
 HDJXNxXRZCiW00YyZW.S0vmGhHA--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Mon, 2 Aug 2010 16:53:20 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: RE: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
To: yvahkNenvaobj@fbsgjner.bet
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> matroxfb (at least with Mystique and Mystique 220) stopped working
> in 2.6.34 - the screen is completely corrupted.

Interesting... I have just upgraded one of my old machines with a Matrox Millenium II card to 2.6.33.7, and have noticed that the matroxfb console has developed a slight wobble. (Think of a subtle "heat haze" / "one too many beers" kind of effect.)

Have any relevant changes been back-ported to 2.6.33.x-stable, please?

Cheers,
Chris


      
