Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1E3Mg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:36:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34326 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1E3Mgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gg62C73m9dJ0Uu5rsrhiLfKPNNq2SdpHnF033tUosbWOlcBh4Y+TC7TzKMS00LvWr+
         CRWR6ZqslLq7c+MqUr6kasgA0wT2Ywi9ciURfSAL5vY4OzjnI5GEL4BhiGorpcCc44cs
         kFoDDAkTGm1tOYqP+YUzTfyQzTV4czhPAIIdc=
Message-ID: <4DE38F62.3000508@gmail.com>
Date: Mon, 30 May 2011 15:36:50 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Icedove/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix mwait_play_dead() faulting on mwait-incapable
 cpus
References: <201105301143.p4UBhco4001230@demeter2.kernel.org> <1306758237-9327-1-git-send-email-avi@redhat.com>
In-Reply-To: <1306758237-9327-1-git-send-email-avi@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2011 03:23 PM, Avi Kivity wrote:
> A logic error in mwait_play_dead() causes the kernel to use mwait
> even on cpus which don't support it, such as KVM virtual cpus.
> 
> Introduced by 349c004e3d31fd.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=36222

Confirmed that it fixes it.

>
> Reported-by: Török Edwin <edwintorok@gmail.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>

You can add this if you want to:
Tested-by: Török Edwin <edwintorok@gmail.com>

Thanks,
--Edwin
