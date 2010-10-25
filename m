Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0JYQKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:10:12 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:28988 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754689Ab0JYQKK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:10:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YcNj4QJL+OpykB6zSnYXjiQ5Sw6HBLVg45tuFFC/54aMO2nvJnQ+UtW9HC3P3bl/td0c4cWYO2/9APzymyaWt5ZQNDfYvsRhZKLY/CEhCNWeVBK4sIp/R2KpJome7GQXuGVosFncSFOn4uoDtDXBT2PhPdH7SC4BlozWRteFtnI=;
Message-ID: <540359.63552.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: RSy.xnMVM1ndewvpPRkKpAR.wR.u827CH.XBls1mAswK5wd
 bT3jX2PDFIHX7yExfL0YjeXNmrqufH0_tWKxrZpzYUVuMVXpZSSHaxrAAmBX
 IbQz5SkPN.3ElWFIl_vmILgkuxB0AB0t94E1Fhts7ax9sQ7hvNYmdulxtzDn
 khkozbw4Rlo9x9JExpIEAY.4gOTejdgWpiDxkPRQfF1gaScKN_RPP1i3r48h
 GyzFCyKQsI95HlnqI2Ei1jRBFFQR5UokywIoq92CItVU_vPD_ixhYMpyEQxr
 WeufgK7UcTFXwNw6g8NOddk6MzCtLTPvq9wQJ1vqBLNFryGY3X.0Wmg--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:10:05 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101025090721.c5d3fdc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Normally, functional
> > patches should precede the cosmetic one, so that the
> functionality can be
> > discussed first.
> 
> More usually it's the other way around, actually: cleanups
> come first.
> 
> Because the cleanups are usually uncontroversial, and
> because
> substantive changes against cleaner code are easier to
> review/understand and because the substantive changes are
> then easier
> to revert or fix.
> 


My problem here is that out of 30 patches, 20 appear to be rewrites and
clean-ups of things not broken.

That's why I'd rather prefer to see actual functional changes first.



      
