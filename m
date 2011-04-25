Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab1DYO2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:28:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56512 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab1DYO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LNaqnWSx5z6vGDfx6ByvElnPxxWIJxOyIGcBdDDqNyOeseeTDBYnUtoD1aB6AM2B9R
         +CThYVcdDfkKH8csGeYM501zzgnI2mh5WDrDvaXuWM1tY0Yby73Ti4jTCe8Z8msONfaA
         1Xz5wDdKPSZC4ZiHapvCZjYqtv80IaYBsUJFU=
Message-ID: <4DB58515.9060906@gmail.com>
Date: Mon, 25 Apr 2011 18:28:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 3/4] perf, nmi: Move LVT un-masking into irq handlers
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>	<1303398203-2918-4-git-send-email-dzickus@redhat.com>	<20110422082636.GC24011@elte.hu>	<20110425133954.GA20887@redhat.com>	<4DB581FD.8080006@gmail.com> <BANLkTi=t7bZ0sFRvUt=a=_54fhXtccPYnQ@mail.gmail.com>
In-Reply-To: <BANLkTi=t7bZ0sFRvUt=a=_54fhXtccPYnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 06:18 PM, lina wrote:
> sorry,
> 
> How do I solve the problem of delivery failed?
> 
> Thanks,
> 
> Delivery to the following recipient failed permanently:
> 
>     linux-kernel@vger.kernel.org <mailto:linux-kernel@vger.kernel.org>
> 
> Technical details of permanent failure:
> Google tried to deliver your message, but it was rejected by the recipient domain. We recommend contacting the other email provider for further information about the cause of this error. The error
> that the other server returned was: 550 550 5.7.1 Content-Policy reject msg: The message contains HTML subpart, therefore we consider it SPAM or Outlook Virus.  TEXT/PLAIN is accepted.! BF:<U
> 0.499653>; S1758441Ab1DYOLi (state 18).

It's written in the tech details of the failure

"Content-Policy reject msg: The message contains HTML subpart",
so no HTML messages should be sent to LKML, plain text messaging only.

-- 
    Cyrill
