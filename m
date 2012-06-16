Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2FPGlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:41:35 -0400
Received: from nm11.bullet.mail.sp2.yahoo.com ([98.139.91.81]:43803 "HELO
	nm11.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754581Ab2FPGle convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:41:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 729521.83931.bm@omp1062.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IUzx7NVcLf5+zYNGecMxxi1XH21iljLyTegNzvydkdfOR+I4AlBlMPshAaUiJAKq+nCU2ojIAsFDdW5fNKWrAaFjtx9xzDwIqTJ6uNLWoCXCB8r348lddDCZHLRPgLiZ3W5Jt7+5p1A/Fpf/8jADi2k4MMXrfyM16/eWRLIFj3E=;
X-YMail-OSG: mx5FJ_QVM1mhZAvyEh0XBUEgiu4KM9snEi_jSGj5Le577SF
 uzRAWJRa.r6UKpzXTe9evTCiv7Wt58eQM_KD5qmqG.EZnSkDRIWMzg920PD3
 9YQdWyblYL5ZhcqOslcIJi81u9OySgNQ8kY6YrfwDGXPlMXO_wNtOAUElgzB
 Y9uXROB4M2PcYm.dNgmSD.pXREY310zPcfXEgoVMVmCutPItXO3xEef3.DRl
 hoVNp.kZEKxqqhDzJFc2k3DyNjlEI8GGJ35RVguNonlfjbJ.GtJVWq3MykBV
 FlQdsPQyxjtoKbuY6pzsGkkNG9SlZc7C7HUbOPxfOBK7Q.N2OcTW6xErDs43
 _xwJ03efPAlneip2DGkJ8w_AXPX8fk.PdnhCwpwZUyJPxyjr9TTDAjaSP0Ve
 175oVKqCYi_mTpHevqc1lGaZxYsSJ47Jl.jripXipOVPfck8h0cPYFVJjiBc
 fPmmAWRFt
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1339828893.59679.YahooMailNeo@web111722.mail.gq1.yahoo.com>
Date: Fri, 15 Jun 2012 23:41:33 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: about interlagos
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three opteron processors with the cpuid that I paste below:
model name    : AMD Opteron(tm) Processor 6136 (magny core, 8)
cpu MHz        : 800.000
cache size    : 512 KB
bogomips    : 4800.20

model name    : AMD Opteron(tm) Processor 6174 (magny core, 12)
cpu MHz        : 800.000
cache size    : 512 KB
bogomips    : 4400.13

model name    : AMD Opteron(TM) Processor 6274  (interlagos, 16)
cpu MHz        : 1400.000
cache size    : 2048 KB
bogomips    : 4399.97

As you can see, although interlagos is the newest one which has higher cpu 
clock rate and higher cache size, the bogomips of interlagos is the lowest!
I read that bogomips is not a true measurement, but it senses as a speed meter.
Any idea?

~MN

