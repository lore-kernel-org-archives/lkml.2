Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab0HEUaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:30:23 -0400
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189]:32055 "HELO
	n64.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934421Ab0HEUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:30:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 118156.18724.bm@omp132.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=kOY1X409WbZdJBUFLA6xfhMJcXqVxTvAevX2QmX97BttdkW8BzopE5iA3hdvPkr6nFjZ1NYU03sMHXQ4xP1QBH9W8LkuAKE1vb6onOX2QOKMgFjp9vAyWAlWZ+0xcn1ShwbPpDa2cuUw0+E3jVItYbPhU8++ylqDb4+zWXIIRNc=;
Message-ID: <921858.63779.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: OllSDm8VM1kEOoQxbMfSoW59uCh8KZrEyVThsX2eSQcSuyP
 86bnGZlsHAqo02hwcVWn_YbTnRKdu8oezw1_AwL7pJqOKxFTcUQuzrxDn.WK
 2hYoxuvVKr3jzjA1F_ZRFbo2D...YRPAskdvdFSimN67OBWA.sddO9xf1_Ea
 .zwpabXxWBVQTySYK..hmwkv2B4DWZlc7REYK1GShn4gBsVBTLGlJAeX112h
 3VZ57oTUrGXf_ihvFxIwlF2B5csvWCGx5fiQNzULyNHm54Yl2XV0BTjV8zhu
 PzqfSUnegcytzhejBADEeEGEId_4cpZvSScPaFQ--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 13:30:10 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 26/42] drivers/spi: Adjust confusing if indentation
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008052224320.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not all of drivrers/spi -- just one
specific driver.  Please update $SUBJECT and
patch description to be more accurate.


