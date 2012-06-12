Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2FLPSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:18:40 -0400
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:44180 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751640Ab2FLPSj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:18:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 753907.11636.bm@omp1035.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qekIjfWb9K5LerruUuxssBz9+J2GLfPPm5ej0tyLyvm+i1kt031TFeQetGshXn5j5ooj+C/hqt864ZHm9bG1XGETXGzZtd/VeoaAAl1Fn9S8y7LYBbY3ymy7hyOxX9IcyqqKnZKIrLWhxGEn8jg8I2tNCZcAzpR3k/f21JS43ks=;
X-YMail-OSG: 6b.x2D0VM1m_jrVkjYwX47rrBCvBlhT0NBocyvVeM7a06rw
 h_Y9BgtxHWM7Z6o6hCjnbygFBK.SFiGSOufXyor3k6dXINnMDza5ApkA6UoN
 GxKGA_KfJnzKpeRQOaglKywJm5Rj2Rj8gNrdYJW_m__zHJq3NEgwkDpklOFg
 puv1huK6v3vjQ9P_QeSTz5xtrtAUEqgqEfDSq69LkvAYBATErb5iFrIkIEYN
 2Dlx.qta3xtSFhruRwVtIHjQly73oETsVEUOxLBSsO2bi4WRP.klHJ91Hy1U
 tYDYK_gHwFJlX.QsMBeaXTXbKGJRG5_bBcolKvgNSolYfNdBOgGexwo3MGKf
 C3rr.r8xzOhoa5AHjQ.f0IS25Lnn..acKkt4eCGRdD9f85NBT.5M8FhOF3z7
 YUEdSivw0pa3oeK5BIgQnJBbW.qP8NphuVOrrwVK.SRZh0ToR7TG5Cj9kuYg
 autd.Rg--
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612103954.GB10124@x1.osrc.amd.com> <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com> <4FD75C84.7020105@canonical.com> <1339514128.5023.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612151713.GB10128@x1.osrc.amd.com>
Message-ID: <1339514318.4218.YahooMailNeo@web111712.mail.gq1.yahoo.com>
Date: Tue, 12 Jun 2012 08:18:38 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: CPU MTRRs and linux kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        "\"\"linux-kernel@vger.kernel.org\"\"" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20120612151713.GB10128@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>He means the latest 2.6.32.x Ubuntu kernel which you can get from the
>Ubuntu repositories, I assume.
 
ok I understand


~MN


----- Original Message -----
From: Borislav Petkov <bp@alien8.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Stefan Bader <stefan.bader@canonical.com>; ""linux-kernel@vger.kernel.org"" <linux-kernel@vger.kernel.org>; Andreas Herrmann <andreas.herrmann3@amd.com>
Sent: Tuesday, June 12, 2012 7:47 PM
Subject: Re: CPU MTRRs and linux kernel

On Tue, Jun 12, 2012 at 08:15:28AM -0700, Mahmood Naderan wrote:
> >And the latest kernel is 2.6.32-41.89 by now...
> 
> Sorry 3.4.2 ???

He means the latest 2.6.32.x Ubuntu kernel which you can get from the
Ubuntu repositories, I assume.

-- 
Regards/Gruss,
Boris.

