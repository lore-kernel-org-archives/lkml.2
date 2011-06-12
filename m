Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1FLGCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 02:02:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52118 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1FLGCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 02:02:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesper Juhl <jj@chaosbits.net>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
References: <1307030444-7095-1-git-send-email-lucas.demarchi@profusion.mobi>
	<1307684165-14742-1-git-send-email-lucas.demarchi@profusion.mobi>
	<alpine.LNX.2.00.1106100955280.19998@swampdragon.chaosbits.net>
Date: Sat, 11 Jun 2011 23:02:41 -0700
In-Reply-To: <alpine.LNX.2.00.1106100955280.19998@swampdragon.chaosbits.net>
	(Jesper Juhl's message of "Fri, 10 Jun 2011 09:56:18 +0200 (CEST)")
Message-ID: <m1pqmj37um.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+fa5akGD63jqR3V/+0NXfeBEgHMQPinO4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesper Juhl <jj@chaosbits.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: remove impossible condition check
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> writes:

> On Fri, 10 Jun 2011, Lucas De Marchi wrote:
>
>> Remove checks for conditions that will never happen. If procname is NULL
>> the loop would already had bailed out, so there's no need to check it
>> again.
>> 
>> At the same time this also compacts the function find_in_table() by
>> refactoring it to be easier to read.
>> 
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
>
> Looks good to me.
>
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>

Applied thanks all.

Eric

