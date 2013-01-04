Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3ADOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:47:01 -0500
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:41487
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab3ADOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:46:58 -0500
X-Greylist: delayed 1304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 09:46:58 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=FEuOJKZ/G7p7j3svp3SIpyPRLE+nuj4b02yI3Jtk5zeASLTBXZfCNoIGqn+sV3Nb;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <19235668.1357309514415.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Date: Fri, 4 Jan 2013 09:25:14 -0500 (GMT-05:00)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: linux-kernel@vger.kernel.org
Subject: no config opt for k8temp in 3.6.11
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb0630c2ba6cdcad3040eb7a32dcc0016b430c2c76f9f60f22350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few systems with AMD processors. One is a AMD Phenom II based system which uses a k10temp kernel module to get the CPU temperature. Another system has an Athlon64 processor which apparently is supposed to use a k8temp module to do the same thing. I have built a 3.6.11 kernel for each system that otherwise runs OpenSuSE-11.X. On the Phenom system the k10temp module is gets built and performs as expected. However on the Atlnon system even though I see the k8temp.c source file in the drivers/hwmon directory there does not seem to be a way in the kernel config files available from the 3.6.11 kernel sources to actually select that the k8temp module should be built. Is this some oversight in the makeup of the kernel config files or am I missing something obvious?

Please CC me on replies as I am not normally subscribed to the kernel mailing list.

Thanks
--
Steven DuChene


