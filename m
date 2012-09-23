Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2IWPZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:25:31 -0400
Received: from nm7-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.192]:46036 "HELO
	nm7-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753990Ab2IWPZa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:25:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 862385.81394.bm@omp1054.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=H5+hFpdoy2ziZgX9s2ck+4dcIpJrx0BdHJeBJc369ZZOxa7aNlXLl8L864+bNV4XTG8oISoncNHiOYqVYFW1Gg3dWZzRUqo42pUv8/HxJ07mnMFLyVaq45Cb9Y0bUeoLlma76yee2RJffR2GWWa9bdRK96qlUmVCjn09Nzs0954=;
X-YMail-OSG: l7H4qPQVM1ktZHlUeWIFpQ2_66YV7if5x_2OTlwT1O5WHF5
 q_0kzE1MwnXh..KGrBc_dPQWxBDAHU10x.wq.jWqbAnbX.iJZpkdhBIUwi.u
 gMZ4roCIzxmibfJWp1s4PMYEBPT5mT9xz5wRHTZ7HANJdBdYdFPGnCJ04.SB
 7KpKYXWqIV4pauWDmZ.ySZ7Qu2a0B4rWlha6SQtyJaVuO4cuKPsy7Ej5FqVw
 T2ffmf9f7RTBb8Gx9dQUg2qC_Nsfh0zzqwfhkTn0kJq6dqsWhNIGII2PXnYx
 pCHizCQmuF2pCGX7B0qDR0CCE1uCn4cU7CyA6shF41BhHNffIRYWygcFFX.U
 ULCaZ_FMkNhWyZgqFm2QVzPf3sHHKsHNtgK6rMlf6zt9vwwpyWymr_0MUxYw
 ttWf9xD6CrC8AXte3sM39fLhjf7PsiE57BtBBuEax.X8d.G7sDF6bWqelxfh
 RwV2wXtKoK92YT7PoYtk-
X-Mailer: YahooMailWebService/0.8.121.416
References: <1348413437.76222.YahooMailNeo@web111705.mail.gq1.yahoo.com>
Message-ID: <1348413929.48938.YahooMailNeo@web111717.mail.gq1.yahoo.com>
Date: Sun, 23 Sep 2012 08:25:29 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: enable or change debug verbosity for kernel modules
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1348413437.76222.YahooMailNeo@web111705.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I don't know if my question is really related to this 
list but need some helps.
I used modinfo to get some information about a 
kernel module. In the output I see a line:
parm:           debug:Debug verbosity level (0=none, ..., 16=all) (int)

My question is how can I enable/change that debug 
verbosity?

 
Regards,
Mahmood
