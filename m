Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0JVAQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:16:16 -0400
Received: from nm9.bullet.mail.ac4.yahoo.com ([98.139.52.206]:36767 "HELO
	nm9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752402Ab0JVAQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:16:15 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 20:16:15 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 332537.6865.bm@omp1038.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=gMqz/bdlI21Tm3LF7WiyV1GFDQKkKEbJyP89JBCPCoqTI9J4Vs/Umh6Ysc6EqSR8bCZBCY8T1+e+tmEaVbJXa8y8gyOn6ketW8JBv7tZbhA2x5QugDWZ0wdgVyIm/VGEOeaRvK7W7tJLcKK+sKGh5ccuuYRYaUfe2Ntfn/faHeo=;
Message-ID: <156151.99300.qm@web50207.mail.re2.yahoo.com>
X-YMail-OSG: P_nUX4kVM1nj8fR4kUnPV0mG47RQFYYs3LHhO4D6uWw6S0i
 E4s7l6SmpcOIxx1AX72OtLV6zpkCFsdbg1fsEEaFv8leMZvERhFUw9Mdp1uY
 aIv5sVu80zJUXPdcA2DKc.z3VWcouYw3G4MZB0602_2e3r9PA4.nDqT6JbCL
 v_RUg3pUDWAEn4X4kgt_VBuwZwV6LbwM0TxcTwY.T5Xp7ALsdouuBJkGe4Hr
 g4m4.2sJbXaWJtawbNSFV1asYYBaHrVWy_dOsClIbynJFArXEomQsruYaRTD
 cCQgXr.jvzeEVsgbiiM6NHN_HHqS5sHjaC4xQVNRt58gErah24ClVWfhK
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 21 Oct 2010 17:10:10 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Help tracing code path
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to determine the code path by which the size of a CD-ROM
is updated when a new CD is inserted. I'm trying to fix an issue I've
found in KVM: http://marc.info/?l=kvm&m=128761750822521&w=2

Thanks.

I code, therefore I am




      
