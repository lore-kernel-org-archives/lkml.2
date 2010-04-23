Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0DWTwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:52:31 -0400
Received: from n8.bullet.mail.ac4.yahoo.com ([76.13.13.236]:29185 "HELO
	n8.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752663Ab0DWTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:52:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 621535.19413.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=4E68DARX1Dlg2ij9O1yJyiav7eILxRbaQV1IkGNl1EUH6rad3XytTIfRUl0muYqNp3j6iKJcRb8DBGsWwRrIBOZWjjfcAlDZNQ8D/7IkGxAITMT22BAcgjL4pwFtkRkXNmLC20jl55+AA98TrLglKF5pY92yO6+XbavJAOCfGqc=;
Message-ID: <382149.89642.qm@web114316.mail.gq1.yahoo.com>
X-YMail-OSG: 5Adem_wVM1nbqFb_F.37JB8j0nBJYswCJm7Nm5zi67cUImQ
 IkWyDS31qQ0oH9iyyEdmrX9qsXU3D91TzLNwBuTxed2kjbIWLhHQ.0KJFloc
 BlYYiONY5oNHlLfpamySidmdSVy8hBnu1HuLxD20yhYFaEmcHcvZoMvy4gQA
 m7RN8WXhnhfChHwNSUf.xdkaoQk2kIUlneVD9KkMIEhzU3kLqM47qCVmd5w0
 EZwe81iRfMfDwVowGyk5xFrnJIt2nHDGxOPIsFTOMDoxanqedcspteF1XEM9
 PE98qPg--
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.102.267879
Date: Fri, 23 Apr 2010 12:52:27 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Re: Trying to measure performance with splice/vmsplice ....
To: "Steven J. Magnani" <steve@digidescorp.com>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100423170554.GS27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

--- On Fri, 4/23/10, Jens Axboe <jens.axboe@oracle.com> wrote:
> I still have patches pending for this, making the pipe
> buffer count
> settable form user space:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=24547ac4d97bebb58caf9ce58bd507a95c812a3f
> 
> Let me know if you want to give it a spin on a recent
> kernel, and I'll
> update it.
> 

I think we need to adjust 'PIPE_BUFFERS' in default_file_splice_read() also,correct?


> Jens Axboe

Thanks


      

