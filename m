Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab0HOWLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 18:11:10 -0400
Received: from web110709.mail.gq1.yahoo.com ([67.195.13.216]:27838 "HELO
	web110709.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751138Ab0HOWLJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 18:11:09 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 18:11:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eybjBFY94Xo+qR83qdvKUF91eMd/UkeT+LlImnxTkSUtoE9IiFGO6TfvvqU3eWVDEz+KtwtEPeea0cf0/nMhSOKEpltLN4BTBdI3hXk02TZagJF8bhM0ReL5dqldB68fw8KFvNckn4i9MUViP2m7esRwir9gh7argjihjp1oeWo=;
Message-ID: <78263.67481.qm@web110709.mail.gq1.yahoo.com>
X-YMail-OSG: t5NDCU8VM1m0oJdOftVktLytmd0GyWQDxhiG4PXz3SuT7NZ
 XWMAE1JMf2D3tPCoRiaMorUOAp_EjitTLcZYlC2eQpGqIeYBhpybofeZwyT5
 mIgeSXFfaALQfIkCbAZoNVrnsyU10pbXeV4wl.V30jHZ8Kpf7.2PRq.Y6Y_D
 0l6u8d_WaURvR2j8SmT4dXU5RTlngC8Xx5j.djghPnpGZM0BbcRVuaQ1LQv5
 SSylY3SD3uERGcf_1qgRI46DeD8wDjIqNF1dTJIjRPFuBWppeFcWVl9LCDic
 eQwGMxfAIiK3c1z6xcJeW9WpKFT.rmkBW6e8-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 15 Aug 2010 15:04:29 -0700 (PDT)
From: Brian Lindholm <lindhobe@yahoo.com>
Subject: Re: [stable] 2.6.34.4 build failure
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've also experienced this failure.  Seems to be a UP-vs-MP issue.

The build for my dual-core Athlon64-X2 complied just fine, but the build for my single-core Athlon64 barfed in much the same manner that Sven reported.  My two machines are configured highly similarly, with only the UP-vs-MP and a couple of drivers selected differently.

I can provide .config files if this would help.

Brian




      
