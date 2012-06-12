Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2FLKXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:23:49 -0400
Received: from nm19-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.216]:27614 "HELO
	nm19-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875Ab2FLKXs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:23:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 596914.49313.bm@omp1016.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=doJuD/AVL5RugY8ACCo7jRHSvaDJk7gniRhq/SHTKbiStEcJmUDVIG/FztuSpq97la7rRSUVE3kr4/cHNskL25l8twNKGYZkH3TBcs+bXegI6UF9GQP/8cyt+9pFiVa2rXmXE49orfVnNWdQ1yMvVgJOoeeXB4lMHDPqXAoxsZI=;
X-YMail-OSG: QkSr44AVM1lOQshX1sXjY.ON0NRjA1E.mdI7lwsBRQ7N88O
 odt8oh.oMQGBArWygjFLgo6e0ZJ8zMkSsGIqSlxkcUwXjyMFIFReadE9ySiC
 fB4LIP2FpG.iGh4twEP7hy62zcYth1pyAcvD0Jt0c73iJWxErcI0e2hjXuWR
 AozxDKjvEysn78SGnzDoOyZhGPs1q8L4LlSo7oh8zZGU0IEeL1xRlAICy41n
 O.o3o1yh27UCZdvKeVCWk2FafhYXjScw.4oUfblhg_yu9t8CzWNGjrMU1rVf
 udvNqaQkfye1pe0p9dAr1XUn2AqjiM5xmVRHRSb4a8bNe4XCp5aAxK08wcob
 kNhnbLU9mDo0m5VQnfeXHL9XoDtXnjkDUMIsfaM8VnaLd79RtqSOtttMMzmV
 2M6I6fCPaqDmug4OsXRZ0wJ4ZdE_smXgVce2Rq8ghZIEli5M_A6009VqmrDV
 Dw60brGJVXGSRsawaXsBI6sThuI0lsPkZrWpFcVdhCPqIjS7CiBjCw0UUkFv
 StJ_B7g--
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612111259.48862b67@pyramind.ukuu.org.uk> <1339496451.43175.YahooMailNeo@web111722.mail.gq1.yahoo.com>
Message-ID: <1339496628.30704.YahooMailNeo@web111712.mail.gq1.yahoo.com>
Date: Tue, 12 Jun 2012 03:23:48 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: CPU MTRRs and linux kernel
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1339496451.43175.YahooMailNeo@web111722.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



BIOS has the latest version. We bought it 2 weeks ago.

I have to say, the BIOS has an option, IOMMU. If it is disabled, in the boot log, there is a message that explicitly state you have to enable the IOMMU from BIOS.
After enabling that, in the boot log it doesn't comlain about IOMMU. However it says that warnning.
One thing that I want to know, is that if it is really a warnning, then there should be someway to bypass that.

I think this is related to OS (here kernel I think). However I am not sure.
~MN




----- Original Message -----
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Tuesday, June 12, 2012 2:42 PM
Subject: Re: CPU MTRRs and linux kernel

On Tue, 12 Jun 2012 02:37:40 -0700 (PDT)
Mahmood Naderan <nt_mahmood@yahoo.com> wrote:

> Hi everybody,
> Abour rhis warnning in boot log:
> 
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB of RAM

           ^^^^^ Note what it says here

> Should I upgrade?

Your BIOS perhaps.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
