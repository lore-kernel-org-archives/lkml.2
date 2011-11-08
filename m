Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab1KHPcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:32:12 -0500
Received: from nm39-vm2.bullet.mail.bf1.yahoo.com ([72.30.239.146]:33819 "HELO
	nm39-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751122Ab1KHPcI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:32:08 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 10:32:08 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 210568.37729.bm@omp1015.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ioT2VpYDGgnnPTKfiVXM6Q1zwUow/yj4JODClw+haS4bxKtAH1wuNMdMdIgjBYr8wZZr2ytSmtByLJeTJ4b1AjYuR/HDxv/cJ2x0j4fSkqyKWAEH6KWMqLMqWYzrNlqbE2HcyOZfKR85Yjfo8TLT50CfVDhvagFD16v2FN5icW8=;
X-YMail-OSG: ClkfdyYVM1lTwEVETw0UYCNof0uUBFr1.Z32d_EP4g19zow
 A_knGr2JVI9GH0uhqaqt0chNGFfrsKwV43tN2RzD_82fvySnu.gVnfWhx_.6
 N86WyoQP8nXVngsCiSEpjC_Sorb7OHCIzMnrjed6k8H5AAXWhsKYTkeRDsrO
 00K4F4JpWRofkHhBOy3iPBE926dn.sneDVVP.P5V4msCgL94bGW3jLajGHk9
 06myLNzkNaYKo3HKJUjGJ1Dwf6jZ6NRuUAZLq1OlwcMJCCn4vogoYDAanx5u
 kCZOpUTiXfNBZCiyn7C3k8hx0YUSEfqIUQFDEFbpKVQE48RF2kVvv6fS7pnD
 VMhAK7gadeojlooMf3_6V6mXz21Mk.nRKdN35chAY7q7FLG_vPbB8qpyRUQM
 ZaC8biFFDps3qDuMBqFS1P53wL_cMi_rJawExpanWrnTyp.uD6g--
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1320766015.85140.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Tue, 8 Nov 2011 07:26:55 -0800 (PST)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: HELP :  Rss and Pss pages are always 0 for some drivers. Why?
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
 
I have a problem regarding RSS and PSS pages always showing zero for some PID.
 
We are using customized kernel2.6.36 (arm with no swap).
 
We are having a menu-screen application (current PID 1939)
 
When I do cat /proc/1939/smaps we are getting "Rss", "Pss" page as always zero for some of the modules  /dev/ump and /dev/mali.
The output is as follows:-
cat /proc/1936/smaps | grep -A 11 /dev/ump
43698000-43810000 rw-s 0000e000 00:11 6751       /dev/ump
Size:               1504 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
----------------------------------------------------------------------
 
I wanted to understand why Rss and Pss pages information for only /dev/ump (similarly for /dev/mali) is not shown correctly by smaps.
Where could be the problem and where I should debug?
 
Any information on this will be a great help.
 
 
 
Thanks, Regards,
Pintu Kumar
