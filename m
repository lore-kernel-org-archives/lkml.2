Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1FZWL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:11:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab1FZWKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EFGcaq10jCqF+akA2rtrIsHO9rALhSW/dHljCcyyhm+zWj1MRBa9XJm03dcQHPExoh
         EQ9PllLOR6Ass9LCxzBPvyVM8QfkfHrEkVmPC06IMlNdu1XFisnKTZfHaiUNZK8bTCNE
         +pGPu7d0NGE2h5RcL1frk88Nyq69AGjhC3XOY=
Message-ID: <4E07AE64.1040707@lwfinger.net>
Date: Sun, 26 Jun 2011 17:10:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #38012] Missing code to load firmware
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.UPD.fZ6BOB@chimera>
In-Reply-To: <XWjMN7gBoXK.A.UPD.fZ6BOB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2011 04:23 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38012
> Subject		: Missing code to load firmware
> Submitter	: Larry Finger<Larry.Finger@lwfinger.net>
> Date		: 2011-06-20 21:44 (7 days old)
> Handled-By	: Larry Finger<Larry.Finger@lwfinger.net>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=63002

The patch has been incorporated into Linville's wireless-testing tree and has 
been pushed upstream. It should be in mainline soon.

Larry
