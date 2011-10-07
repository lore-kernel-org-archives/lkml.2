Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875Ab1JGIoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:44:34 -0400
Received: from nm10.bullet.mail.sp2.yahoo.com ([98.139.91.80]:22629 "HELO
	nm10.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759515Ab1JGIoc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:44:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 585406.15381.bm@omp1043.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qJUfbCtYKFJO7RsoaU4PtSLtkaQujnMUAw1pt/G+jm2wDnafsUHTvICXYtLyz2Qn27nCR0ywOWQa0u6EEtFVBoEuzNE6Vzw40PrYjMb9bDhmMJ2MsAyJQWrskxdMBAR9UwW6Av2hUwYANAy2pDyKjkGaGg0bvPB9Poki2aDPBSY=;
X-YMail-OSG: cy57FoEVM1l9Qx36Rxwx97ojFcxowIK1lgjZYn3jqenxUN6
 Zj5UlU0c.MLhNx8CFfxGSVgh.LQe4zkl5wbfQQ2dzObqPecx3j1Pojvgxsw6
 AJOg7gdQquaJGZGu34mHziFH5PdDk097Ryc.0wd4_pusXdtrwRGdw8Ej6WJi
 L1h6Ammn1c1cpbZhNAskv4OQg4vOLxLHF8x4lPAuccOaiNw2tRKVfhulUYGE
 W2NhaEtz6RC4L8fFSXlYVTWaibzEFzAePz_1w5NNPGmdJL83USriy7tU6zYq
 4gh2mThVLPkdzjHZbvjRHo.D.FVna_M7AiJY7hWA1HOmFIgOVCeOhzRe0.6X
 BYtEtS119iU6IZUCQE7SgzPHdNWJPyMJjH.0mYVEWULg0w9fgavFXTWhvkhO
 nUkolTzDvWIU3XiukIjv_mshXWmbtg6EEPn8797yRcPxGL.bF8ESvrlMmEqD
 oMU0QDpoCDbbC3kdSxyGtFtPyhgCiK2gflHmRt3seN28_simmXDrtl2jTHki
 6Am09CfJRjCLqVvH7CTt4_16ayK3R0DQfotg0uUKN6_StWr56Ilo1sB1g7Ku
 9lLt2rBUMMWkrn_klFyddwFsqtLG9zdKvr3VCxv0LsSIq
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1317976819.47237.YahooMailNeo@web30304.mail.mud.yahoo.com>
Message-ID: <1317977071.75134.YahooMailNeo@web30307.mail.mud.yahoo.com>
Date: Fri, 7 Oct 2011 01:44:31 -0700 (PDT)
From: AW <arne_woerner@yahoo.com>
Reply-To: AW <arne_woerner@yahoo.com>
Subject: Re: acm/ttyACM0/cdc_acm does not deliver data
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Josh Boyer <jwboyer@gmail.com>
In-Reply-To: <1317976819.47237.YahooMailNeo@web30304.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Can you try a kernel.org release instead of a Fedora kernel?

>
never tried that... can i just download a rpm and install it?

>  If not, please post the output of running the usbmon [...]
>
I did that:
On the 2.6.38 kernel: each try works fine...
http://www.wgboome.org/cmd:Z-L-0,2.6.38.8-35.fc15.x86_64.usbmon

On the 2.6.40 kernel (=3.0.6?): both tries failed (but the 2nd try with slightly 
different beginning):
http://www.wgboome.org/cmd:Z-L-0,1st-try,2.6.40.6-0.fc15.x86_64.usbmon
http://www.wgboome.org/cmd:Z-L-0,2nd-try,2.6.40.6-0.fc15.x86_64.usbmon


-arne

