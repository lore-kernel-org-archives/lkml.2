Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0JNIAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:00:37 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:42707 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754839Ab0JNIAg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:00:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YsjMf7I8jO80RyRSxZ6w9OVrow8RmlaT8mWQaGB95EoJKHnmnTlIcfv+avAufOEqxxwcfCaeHogoMTfb8sxOeRiPxAD9EbqQlqFxf/h+56fZsHwpG3WbrM2jmFERNCCy9Gbtgam+0MwIhA1nvhOBP1k2UKBltz2J59g5CqEZhgI=;
Message-ID: <8497.77981.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: LBTCgiIVM1mB3uGtowPt9lux3qn3itd7tclapeOI7zMVKMr
 m_j3G.Na8hTP6RPmb.HM6_pIv7o3HuRfo2wFB1lHnYYSnJiGnC64cq1FrCi0
 Iv0OrtxwSVft6drjR_W4_l1aD3b0WpQgRU8ME1tcHN0KwJq5Ixawp3ztPNIx
 w_5jFRuHQpFam7a9UByqnTngGb7dM8NzzU.KGv6R.hgIA_DhzDNGy6JNuHI1
 .knxBjmIZplvijMTlgM.SZF_1TCwMBLpht.nlOT0QuT5mTf4KBYNhjM4jI6l
 8IdmLTyCD206FeOUjl.ar5QlalRfuEmOSIhHXS3U8EGLyQjxxSxn3KJ1feBI
 XioT9Jq4RUGiRFoJLdz7p6N5Nsg4-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Thu, 14 Oct 2010 01:00:33 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Results of my work on memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> and patch #6 contines adds even more cleanups, and makes
> whole
> memctick subsystem look nice and clean.
> Many non obivous functions were removen.

Replacing functional state handlers with nasty 3-page long switches on
undiscriminated integer state variables does not count either "cleaner"
nor "more obvious" in my notebook.

This is a matter of personal preference, I suppose.

Yet, at the very least, you should define an appropriate enum and give
your states readable names.



      
