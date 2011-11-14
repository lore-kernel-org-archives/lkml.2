Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1KNGIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:08:10 -0500
Received: from nm17-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.157]:26279 "HELO
	nm17-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678Ab1KNGII convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:08:08 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Nov 2011 01:08:08 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 64325.19358.bm@omp1010.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mcVhr3Q8wZqPAHFEIx+N07iY74PtbPxrCMmT0QPlHc6hHu7l0fuO5meGoEF5hvBBUNs6CLvdd4QFj/m7ma8t2STJcXL0kUzj/KXsiaoynBx8OUReFEQMYdMtNLR0L/rBqpxSakXwEgWuUa3mhHqjZb86h8L7JMmwc1NVKwN4fec=;
X-YMail-OSG: lMmKXO4VM1l3.kPVKhF4zZTB2VL0vmVAU9xjZZLlOGsx17v
 Z13ww7RhnDDUOdQ35jx2fzZlnhGz4PdfmsfwoRZTW550uoVp7R1f.PZpDkz8
 4jqv9Sph2fhap6b5QLC.lYrR3jrI3qr3Ex09zYq7cd1Hks8uNby2dAwlB52x
 BuJtW85x1T1tl3j8pbRPN9cn.o9uQqDeYcTRJJaTUdgB5Cjd5mUZ8P5R4oY1
 bIdr3Jx_fpH0Ec.Qn5vS_jPFoMJH7nVKBN1h0pX2DRx50FQmN7AZeqGcnET3
 6MhX.bTfE5amRb97yjteJ86lyDmC53pBnYGaKXabva1G4RuHODjOVmK_kbeW
 uqhzGNpQ.eHfHzB_9Xl2cYGnqtxeLRN8TtVS03A9hxXSLZrvTa_Qz3lb47M8
 XRP0wzXzsAzLGNxfr6STbUG3B4lPlVpoPWxcNNRiaiuyLtMCMrW2EYHybMNb
 qz.fxNubdkeVX5.0EiSWLoEdqAH1wnJGJQUXS4iBcPoW40ctyf8yIrS0D1sg
 SBxRdMUx4DCGbI_2DOJE_QQD_1ou.Z_mnW2p0ZhITHa2dgh8co4lwEIoMxOU
 u5F8DwE_eog--
X-Mailer: YahooMailWebService/0.8.115.325013
References: <1320766015.85140.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Message-ID: <1321250527.64002.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Date: Sun, 13 Nov 2011 22:02:07 -0800 (PST)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: HELP needed :  Mali and UMP drivers : Rss and Pss pages always 0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "pintu_agarwal@yahoo.com" <pintu_agarwal@yahoo.com>
In-Reply-To: <1320766015.85140.YahooMailNeo@web162006.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

This is regarding the Mali and UMP drivers for kernel 2.6.36.

The Rss and Pss pages for Mali and ump drivers are always zero.
When I do : 
#cat /proc/1936/smaps | grep -A 11 /dev/ump
43698000-43810000 rw-s 0000e000 00:11 6751       /dev/ump
Size:                   1504 kB
Rss:                       0 kB
Pss:                       0 kB
Shared_Clean:        0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:           0 kB
Referenced:              0 kB
Swap:                      0 kB
KernelPageSize:       4 kB
MMUPageSize:         4 kB
----------------------------------------------------------------------
The Rss and Pss pages are always 0KB.

Any help on this will be great.
Anyone who knows about Rss and Pss pages can provide some pointers to debug further.


Thanks, Regards,
Pintu



----- Original Message -----
> From: Pintu Agarwal <pintu_agarwal@yahoo.com>
> To: "linux-mm@kvack.org" <linux-mm@kvack.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Cc: 
> Sent: Tuesday, 8 November 2011 8:56 PM
> Subject: HELP : Rss and Pss pages are always 0 for some drivers. Why?
> 
> Dear All,
>  
> I have a problem regarding RSS and PSS pages always showing zero for some PID.
>  
> We are using customized kernel2.6.36 (arm with no swap).
>  
> We are having a menu-screen application (current PID 1939)
>  
> When I do cat /proc/1939/smaps we are getting "Rss", "Pss" 
> page as always zero for some of the modules  /dev/ump and /dev/mali.
> The output is as follows:-
> cat /proc/1936/smaps | grep -A 11 /dev/ump
> 43698000-43810000 rw-s 0000e000 00:11 6751       /dev/ump
> Size:               1504 kB
> Rss:                   0 kB
> Pss:                   0 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         0 kB
> Referenced:            0 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> ----------------------------------------------------------------------
>  
> I wanted to understand why Rss and Pss pages information for only /dev/ump 
> (similarly for /dev/mali) is not shown correctly by smaps.
> Where could be the problem and where I should debug?
>  
> Any information on this will be a great help.
>  
>  
>  
> Thanks, Regards,
> Pintu Kumar
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> 
> email@kvack.org </a>
>
