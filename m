Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0LGL3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:29:40 -0500
Received: from web31702.mail.mud.yahoo.com ([68.142.201.182]:46004 "HELO
	web31702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753105Ab0LGL3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:29:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZOhZofNd5ZT5aeAheHMp8zuKZoigcGtgibfX62Q7IGys7Vw+H60fMsOiZOrx1gq3/ZmtTyi3IqGlCV06HuUfeQnkm2DdEy8j8ONZbJLChX/OUBFjrAyUeQ40j8zIw/hEDKW1d8obSH/vLAQ/qMbxYfNzR//lIEhiNpzJPK4AAHE=;
Message-ID: <712019.56679.qm@web31702.mail.mud.yahoo.com>
X-YMail-OSG: F4UawI0VM1lhC9zOfP_PgKJ8hYaDHo1d4xEElQD.9PqqzLy
 IMR5yuk68RPv5h6qZ_3go6QJWvYDc1N_JfKMsGPqpTzDY4kBOEKnswzDRtfw
 _S7Bq.XRcAvwlRTj6b_BGtJJK7EIzhfflcYJfEBWkLJ3MyPWVzdgX1abI2zJ
 tyiiLw.PllgiHthOk2HV3iy_yuoqdjDk4kWez5vrCdVNhlLqb6jeb243mSVm
 lu0lYgq2oteC8cObqHPOStTub7MVLoHXWC.lU3BSq6mEG.O_Yljbfe1ZoFQV
 _Z8I35PB_h_YQdbOM9_KS9BMmNT0bkPWijUeVS3.HISwEiZh.b70T7G7eXjK
 7L1FZ
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
Date: Tue, 7 Dec 2010 03:29:37 -0800 (PST)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Posted Write onto a PCI end point device using Linux
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I am wondering whether it is possible to issue a posted write using the host 
computer's root complex towards an PCI express end point. I have done this using 

DMA in the past. However, if posted writes are possible that would save a lot of 

time and effort and would be quicker too.

Thanks,
Sanka


      
