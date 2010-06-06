Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0FFPxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:53:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab0FFPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GBgntwgihrSkE8l2OD6dE9hEYat4WtFRr52C2uD/h90qD0ZIAQuxhPyBKst8U9ZjJc
         vT7PxrGSrH+t61DkEPzCVOwzvXKBw/Hc2rjVW+bAE53TgqZvL8lvnsXDhsSPnW2htcjs
         YpT2d9DPyjpvStj6LjLooIKjkl96qDle9Md40=
Message-ID: <4C0BC45A.6080104@gmail.com>
Date: Sun, 06 Jun 2010 17:52:58 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: Linux 2.6.35-rc2
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org> <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com> <alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org> <4C0BC35C.8070003@kernel.org>
In-Reply-To: <4C0BC35C.8070003@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 05:48 PM, Tejun Heo wrote:
> Can you please try w/o KMS just in case?

Also, does it always crash the same way?

Thanks.

-- 
tejun
