Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1CTR60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 13:58:26 -0400
Received: from web39404.mail.mud.yahoo.com ([66.94.238.180]:30290 "HELO
	web39404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751948Ab1CTR6Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 13:58:24 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Mar 2011 13:58:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=V6sqKCVh5oubNos5QRjlyuCqEVA74jj5oCPYs1P/oAUxqj/tuyIbmBE7aT+3cW8Bg1DqxtFD+JkBKCEjZCcNf6HTu2WjEtxhNcmKEvFEi40EYrEcewaPqB/OUkocvAM12VfM+CHQq7RuOB4Y4Y5CQDafnDEf9qs4DjGMhXvjSkA=;
Message-ID: <559636.89511.qm@web39404.mail.mud.yahoo.com>
X-YMail-OSG: qgd.yboVM1na0JXONvv31AYFmnz0HAK3O6o0KHR.ML6lEuG
 ejxVR4ID8xmjwyOkLJBrDkRJMOSFFTrL21CooCCbim1fa0s0Zrl1K2Vyy3k4
 V06G6y8CnlK60A9vbyJmQoQf77fTydVpoZtE_fP8bR3aOCBLz1ZxNa4.oXgv
 kg9FZ55Ve_u_XUnHN5s0FaoEZNwEClfnEML5II_FyMw.pzJ9Su298EjRcEVy
 xcoFwb6AJFD17XnU1hki1bufg.D_OH56BITdhULmOAV6C_X9NRRTct7M6.Td
 gDpxD3Xu1RMG6z9eupDabuZv90q813dKwBXWoJR7i6mw24Bsqpg6rlPmG1J8
 qYMTgI9GB4FszcpfjPbEZxBbJgr1RKiaIjOILzvIYcv6ePsYtWQrCrPney_h
 7MDOh7X2I9qkaQA--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Sun, 20 Mar 2011 10:51:44 -0700 (PDT)
From: Kenny Simpson <theonetruekenny@yahoo.com>
Subject: Re: remap_file_pages doesn't like MAP_ANONYMOUS (but used to?)
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.1103191525180.1609@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 3/19/11, Hugh Dickins <hughd@google.com> wrote:
> Thanks for reporting.  It was a simple oversight: and
> until you came
> along, nobody noticed.  Here's the patch, I'll pass it
> upstream shortly.

Since this bug has existed for a while, could it be pushed back to the various stable/longterm branches as well? (as they all are affected)

Many thanks on the quick response!  Glad it was a simple oversight with an easy and obvious fix.

thanks again!
-Kenny



      
