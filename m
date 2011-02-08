Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1BHJlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:41:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50466 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1BHJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:41:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 08 Feb 2011 01:41:32 -0800
Message-ID: <m1ei7iamnn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/C75Rf8YUPEur8wFjYhBktAKHrLZ15+kU=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Does anyone have a clue what could be causing this?  It looks like
getpeername for ipv6 has changed in the tcp case did udp possibly get
missed?

Currently curl is failing for me like this.  When doing a tftp transfer
over ::1.

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0  200M    0     0    0  570k      0  12.7M  0:00:15 --:--:--  0:00:15 12.7M
curl: (55) getpeername() failed with errno 107: Transport endpoint is not connected

Tomorrow I will dig deeper but for tonight I wanted to ask and see what
other people see.

Eric


