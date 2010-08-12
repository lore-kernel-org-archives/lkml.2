Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab0HLWeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:34:24 -0400
Received: from n4b.bullet.mail.ac4.yahoo.com ([76.13.13.74]:27813 "HELO
	n4b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754518Ab0HLWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:34:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 654415.6179.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=yzQeJ6rgujjLiv1xhzpUolGADus+hhZ+f+NlUenspy0JDVjjJTWB5Yt3ukegpF0GOh0NMSvloV4/lzCcbyUs0ez6UozIRkDcNM1+F27eurl69f3+ZZr38SZ+N5Pgaf6b0gp2+sarwe35nr+YAplGmIfLCG6WNnjZKyMIm2013do=;
Message-ID: <449572.54202.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: j3zedzQVM1nfj.muo1WwzmgXWeiTBk_Kyve6lFnidbYdKPC
 aLi5O5mlwiea6H0T_SSV8LCRVFOKPBSzcJZNepBqi3AQ1nt2dMHiW5nNpjfk
 9.8jZVQf3qbH0tF70.IWppXF_U_4zu8iFNy4xbW.obnQYBWVP9drI0VjPfbM
 olm.iiC6m7lN_oz8sl_0FLc3vd29zYmFwQ9x4RJAJU5Caa4X.ARjozd.jn6F
 5j5wMHDU_nkq5v28KS3Bv5rSqr75HfSr4Bq_fKB3BOVw2NIt3G_bEFv_1u7I
 M1ebk0F2gDHLQJ8UR_9.bN7bv1M9yQJmTJrcR_SbF1oc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 12 Aug 2010 15:34:21 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv8 04/13] USB: gadget: mass_storage: moved strings handling code to composite
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK, but I can't test or give it
a detailed review just now.  An ACK from
Alan would be nice.


