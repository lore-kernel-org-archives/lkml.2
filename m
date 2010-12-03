Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0LCBL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:11:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36294 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab0LCBL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:11:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J+/wBp1mSQN46E9L9Y+Wj+/KHHxDkgc31HntSjT9CaV63xDAWDQgGi7JtC7YgG1nlo
         5jTdHP6z9+VvUJcmKgQa+2fT4Hk4tKyw7q5wvI1Biu/vS7bokUzmHXfE+cCdKmxZEKLF
         V95E8K+/Hg/vR4I6/E5sbRqqawxPKBLdvkL4I=
Message-ID: <4CF843D1.9050306@lwfinger.net>
Date: Thu, 02 Dec 2010 19:11:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #22672] Regression in 2.6.37-rc1 for Intel 945 Graphics
 Adapter - bisected to commit e9e331a
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera> <gUkHV_Vc3aE.A.NG.RzC-MB@chimera>
In-Reply-To: <gUkHV_Vc3aE.A.NG.RzC-MB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 05:41 PM, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
> Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-11-11 01:56 (22 days old)

Still present in -rc4.

Larry

