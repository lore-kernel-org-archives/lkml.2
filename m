Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2HOErT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 00:47:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53928 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2HOErR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 00:47:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
References: <87ehnav9n5.fsf@xmission.com>
	<1344889115-21610-1-git-send-email-ebiederm@xmission.com>
	<1344889115-21610-6-git-send-email-ebiederm@xmission.com>
	<201208132326.35045.remi@remlab.net>
Date: Tue, 14 Aug 2012 21:47:09 -0700
In-Reply-To: <201208132326.35045.remi@remlab.net> (=?utf-8?Q?=22R=C3=A9mi?=
 Denis-Courmont"'s
	message of "Mon, 13 Aug 2012 23:26:34 +0300")
Message-ID: <87has4hicy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/dtV5jRsjvsYu3klxsGDXCH+381rQuZK0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;R=c3=a9mi Denis-Courmont <remi@remlab.net>?=
X-Spam-Relay-Country: 
Subject: Re: [PATCH 06/21] userns: Print out socket uids in a user namespace aware fashion.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rémi Denis-Courmont" <remi@remlab.net> writes:

> Le lundi 13 août 2012 23:18:20, vous avez écrit :
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: Patrick McHardy <kaber@trash.net>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Vlad Yasevich <vyasevich@gmail.com>
>> Cc: Sridhar Samudrala <sri@us.ibm.com>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> FWIW, ...

Well I will take every bit of review I can get.  It can be terribly
embarrassing to discover you messed up uid/gid handling and no one
noticed the security hole for 3 kernel releases...

> Acked-By: Rémi Denis-Courmont <remi@remlab.net>
