Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1IYVNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 17:13:25 -0400
Received: from nm21.bullet.mail.ac4.yahoo.com ([98.139.52.218]:20772 "HELO
	nm21.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752955Ab1IYVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 17:13:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 754780.38141.bm@omp1046.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=a3lqb1szlNbn3d1sbB9fFaDkPfN66moeuKUkkKg0lmygt39aYedx7eIwBm/P8s2QUH7y9cytERZIZaMo0V96ZB8oNWnk/E66EfIqFUSaGpETiIbFdFBhDzgxzPCTZsrVRgk0izOLJQdUGtp8mYL8R5PrGaDqEN8KsZgxe4saFSU=;
X-YMail-OSG: 5deOAOwVM1kVJKBWBiuTeKiCaDnGGMM95uYdjZpy4jhmwtB
 Ss3euR6hw3YZNt8c9I.IXoZOdaJUfUcTcrZbJpQLwc99gVY874MOZ6keUn2f
 B8L0VDC3KMLwbpkLmuwwkLnSYTqcWxwfrcAiPs.Gs.FjA5URkDNlaw.805BW
 3cQP_iwBfxD95LM9nW.7vekJBgK0M_u1F.Kei_7wzdI3a1q72v8ixvB5D7Na
 gkTM9jG7D0HOaE7Qmu086N.r8S_eMaY2NpgEES.YuaRZOMlG4Bd9GODb9zcV
 FJ7fM6ers3Mq.CyfTN.sMlFmPiqVGneL2uCHNumI7NqA_yVW241mKw8.c8lA
 aWkdBPeRSNlBoTbtlM1OXgouQt5KY7fQKBrLfMSjQnFQr_cSOPwk2rYEiMIf
 O9oGEencrhkXwJCvMgNh8GTlyCO.CbZmzqO_DMZj43XkO1RMpViaQGh05V1r
 7Bg--
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1316985201.14303.YahooMailNeo@web130120.mail.mud.yahoo.com>
Date: Sun, 25 Sep 2011 14:13:21 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: Regression: i915 blank issue on kernel 3.1.0-rc3
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keithp@keithp.com" <keithp@keithp.com>,
        "mjg@redhat.com" <mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>Matthew - this is your most excellent patch which adds a native
>backlight mechanism. What other info do you need to help figure out how
>to make it play well on other machines? We've got a handful of
>regressions about backligh in the 3.1 RC series, and I'd hate to have to
>revert this...

I'd hate to have it reverted as well. Without this patch, my laptop screen is too bright to 
look at comfortably. Fortunately the workarounds make it usable even in its current state.


I code, therefore I am
