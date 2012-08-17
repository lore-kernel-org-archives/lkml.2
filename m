Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HQTWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:22:11 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45384 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2HQTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:22:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Budig <simon.budig@kernelconcepts.de>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <87k3wy1ii3.fsf@xmission.com> <502DFC1D.20903@kernelconcepts.de>
Date: Fri, 17 Aug 2012 12:21:34 -0700
In-Reply-To: <502DFC1D.20903@kernelconcepts.de> (Simon Budig's message of
	"Fri, 17 Aug 2012 10:09:01 +0200")
Message-ID: <87boi91g01.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/h2AFC4BnedgTMCH4vHMGkTdsbcgZKosc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1066]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Budig <simon.budig@kernelconcepts.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Input: Let the FT5x06 driver build without debugfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Budig <simon.budig@kernelconcepts.de> writes:

> On 08/17/2012 02:15 AM, Eric W. Biederman wrote:
>> When testing to make certain my user namespace code works in
>> various configurations I tripped over the tf5x06.c not building
>> with debugfs disabled.
>
> Sorry for that.
>
> There already is a patch for this issue which I slightly prefer. You
> can find it in the mail from Guenther Roeck:
>    http://www.mail-archive.com/linux-input@vger.kernel.org/msg00646.html

If you guys could get that merged into 3.6 I would appreciate it.

Thanks,
Eric
