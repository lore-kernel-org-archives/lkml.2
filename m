Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0LSQZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:25:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42599 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0LSQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uhcQjX8bzcD+vUOCoDMycDbJGS1wRogk1FjYj9CjEPIdpnhoyYbyVBpFe/0KLFyArZ
         jyEQD2KCAvhOJUmCkc+ZroUXz9CzKzbsaEtNHnNvb6CRtRMn4OVB5FQRs6u2NssThGQj
         2vnNjNLR9K9jKfq4hGuFPC6Q0IEy/ZeTFSqRk=
Message-ID: <4D0E31FF.9060104@lwfinger.net>
Date: Sun, 19 Dec 2010 10:25:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #22672] Regression in 2.6.37-rc1 for Intel 945 Graphics
 Adapter - bisected to commit e9e331a
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera> <6Ue85L6pKCJ.A.NVF.qffDNB@chimera>
In-Reply-To: <6Ue85L6pKCJ.A.NVF.qffDNB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 06:34 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
> Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-11-11 01:56 (39 days old)
> References	: https://bugs.freedesktop.org/show_bug.cgi?id=31803
> 		  http://marc.info/?l=linux-kernel&m=128944001311444&w=2
> 		  http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg02235.html
> Patch		: https://patchwork.kernel.org/patch/359472/
> 		  https://patchwork.kernel.org/patch/359502/

The problem is still present in 2.6.37-rc6.
