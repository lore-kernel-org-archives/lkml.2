Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0HNHIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:08:17 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:20557 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751946Ab0HNHIQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:08:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ea4xcseqSMt/YtxARp6lue/zkLvYl50v/GGNsWCWHQsBFAM5Ck04sfpQYMZzlhTUj/F/NECBhzpPaSR2SMTpvGbioALiS1Re8GNngu87HJjeEWAtfuwd8LNQF5mMUTYNMxNNKktG3/2yqfKfyJOk/rCKA9/JUrnke8wS3rw7QiM=;
Message-ID: <728075.56624.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: Lgkh.FcVM1n91V2iIp6GD_oeRCucltLYScVCAvecYWX.Txa
 3ZoUGDyj4Cl2nqSv.WSK2f.3j9vFneHiQf4jquwxLdhvcViyhyuldquHLoNm
 .eDMjmbAt843atp4jtuf2oLby4SXGxjI3c..cTuSeuBWQz59mZ9tsRKPb8Us
 UIIetIlpiYVgGpnUwr2k5z4t5Gk0Ec_gKwJY5k6SoMTtmHend5nvQEoM3HYL
 jOlRZwvhmD0si_1eYS1_Hu8DL3rLxxIPTEXaRUahRcb1RMksc2cjEAWfYR.h
 QBdgneNiRu.iaxGTlRg--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 14 Aug 2010 00:08:14 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [QUESTION] Need some explanations in regard to memory alignment of requests that a block device receives
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1281706071.4160.18.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> However I am opting in to allow to receive requests that
> have many
> sectors span several memory regions, and be in highmem).
> The request is converted to scatterlist upon which I
> operate.
> (Untill this point I did the same think Alex does in
> mspro_blk.c)
> 

If you'll look at what is actually there you'll see that neither of your
questions poses a real problem. But, of course, block layer is more
conservative, for what I can tell.



      
