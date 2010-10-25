Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0JYO4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:56:13 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:44925 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753078Ab0JYO4L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:56:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=W4csuuFm9ceiVezfyTnUou0Tawo9I1eM2neFn38xX5/ognORv1K/3xGOxmxRWZMy0GUoMceJ7PEctaPLDhEF6aTjGy/Z5j1WWBg2N7wYdNlnNHVr8y9NSNBbd/4MvwosPuVhTB6pCFgxWsp6FOrEiQVz0Wa9xmMioTB5qROFdT8=;
Message-ID: <117301.25688.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: W4OqaVEVM1muwkpZsGGNrVe3WQsNTfTDNnsi2eyS1RofgtN
 P_1EXhrZNupYLriZXnrH_cYdxDUc72MY49X9RTK3ISVDflFMq0vYZ4Rvgj3z
 g5Ej73A8.KFNCvpp5Pe5GoBMf05mUYH7Txbx8wVafet9IDYAaZyyCtHPCDpy
 fl2FM3NqnJt707jeHNlqHSosg1mRUS4vOkeiGqTO.cSqhStTVcd8GF2eiZHR
 0VFsW9Ycklra9DirTvM2.xmV_ZPvnnMzhTqmyuBLAEmWPx9vl4XNyX2MG2sH
 X.4mNr_lDbueOBKrg876md31n5PoQdN4KK3H6qjNSmgcZdYjgCIH9fXrcMsp
 5EySJYhy_UHto80gKmwdaQd0sg0M5sGqr016X1teKgXY8OWulRQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 07:56:10 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 03/29] memstick: core: add new functions
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-4-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 03/29] memstick: core: add new functions
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Add a lot of support code that will
> be used later.
> 

You're adding here a lot of temporarily dead code, which, while being
useful, should be better added together with the actual driver
functionality.

Besides this, the patch has a lot of unneeded clean-ups which are better
be set as a separate patch.

And it doesn't conform to the coding guideline either (4 byte indents,
instead of tabs).



      
