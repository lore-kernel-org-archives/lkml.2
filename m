Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0JOGpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 02:45:53 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:31448 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756109Ab0JOGpw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 02:45:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Q3fvjZiRGiDgrkimMjVoT6S2B+QE00ji0cD498GXQv5/YXW+2aAtLeKH6i+un9zExK5lYEgZr/1VMT61Nk/xfamcw2XgQo9t6CZsh54IAYvESmYZ3Hq46u2MUE8R2TP6xgQgxvyGA5m0TR1RCSiYe1zoednv+ewiu0h39pasoWI=;
Message-ID: <463093.9879.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: lv._72AVM1khVBlyUTW00cjZSXX6h_IMKlL7oUZ6YiSYyNQ
 sZIfhaTCTYb.8MNZJPYgkXCLEYoxWBWybHRCXt7ymkXQZdzeju4WB1PYHYko
 mxk.sJ3KTeTFIwSTzP9tpI8gUsPtKDsANTx.XzBNmYl1jl5008mCXSh31N0q
 Hv.w5IIsAyvte6JG0VGCoj7ilZh5N.cGP.1kS9Cms_lFUIul4Ehyr20kpKAf
 WhSN1_B.e9Y5IbWr6jxO2ZcdlvN024gZv74QYSXiDoJnx64C_yN86f0upIQs
 YMp8L7u9Gr6Thm_NXxp59SCkgKOXEjzahW4MFgeUrDKebfmDMzuorLuE-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Thu, 14 Oct 2010 23:45:51 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Results of my work on memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287090073.4301.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 
> And what I had to go through to understand the
> mspro_block_read_attributes....
> 

Ellipsis to the rescue! :-)
This is just one straightforward function which parses the header block
in an originally intended fashion. You can simplify it by making it "less
correct", windows driver style, but otherwise I fail to see what could be
so difficult about it.



      
