Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0JYOuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:50:37 -0400
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:39866 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751518Ab0JYOug convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:50:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=oNIDUTFRPT9UZSWEdmp/yYBxR7h6uvz2un5qtPkvNw5iRd9d28ORvz4b2ROH4mzjlaOydxFZKWaq71kCTKqyzsqzTn1fcs82mKMwulPq93EuGOZrC1m3CK4x+nBLMGsr4yEMd023HoZBqylE5/oceRfUVgo9akKXcLiMk9zCThQ=;
Message-ID: <779344.19696.qm@web37603.mail.mud.yahoo.com>
X-YMail-OSG: qpW85BUVM1nY7OzKcH.nH8sGSoXDiYwzDPHjINxALn6wCzo
 05tcvm3cPOBInoP3c1bfFWHJqO9DW_.obYR_hVwP2o18cV2nO4rRx8uo5XoC
 _M5ncBHs7.8VAyZw6Ksv.._N7bDETX_hBN40xCt1.ioriwGdLKG1HooAS_Qe
 KhoakL5hruhnmxdteMNMyyVPRsZE5F0L8vgx.D_kOODBFe1b6TP9vIhneSkD
 EPXBpoJaJjSH3d86.eL9glyo4GcWna0pjLUMz3jgBGFlhG.iXo0C1a6mQF.O
 qmV.RUs1X1uxLRWLUQaWqs.MOKdfYuKN5OW9Fd7oLgafQdrJgSfyXvErF_.Q
 XwvuKTEcbNXjOoTCYdmAMQwg.C97xngS7nio-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 07:50:34 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 02/29] memstick: core: reorder functions This patch just reorders functions in memstick.c So that host specific and card driver specific functions are now grouped together. This makes it easier to understand the code.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 02/29] memstick: core: reorder functions This patch just reorders functions in memstick.c So that host specific and card driver specific functions are now grouped together. This makes it easier to understand the code.


I'm not sure this purely subjective patch is of any real utility.
And at any rate, it belongs to the end of the patchset (where the clean-up
normally go), not to the beginning.




      
