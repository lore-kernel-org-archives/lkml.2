Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1C1Vfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:35:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53515 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1C1Vfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=PwBUWLBvLQ1DYFFHMVZFdvl0vbCrpD6wvzVX5PIq41APlG4NyJnQAlQTOY8KG2XfVG
         zjwtyc/iTxyl+eUCwWoqFWKScmrITRFFEb/TsY19MShoWwfZXwdZsXheHhLY7Y+CXl1K
         6aciqvqW0l/dNk4Si9gW5WmqldFwGafrtnqWY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6>
References: <cover.1301324270.git.luto@mit.edu> <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu>
 <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 28 Mar 2011 17:35:12 -0400
X-Google-Sender-Auth: 9lU5-A9X0CG1FZpRXRskAFH3Obs
Message-ID: <AANLkTik7d1LNhHHOf=twXbKfMbU3rRCqW6vMzWGk8s31@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-64: Put vsyscall_gtod_data at a fixed virtual address
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 1:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> NAK.

Consider this one withdrawn for now.  I'll redo this patch later on
and resubmit it on its own.

Any comments on the rest of the series?  They're all independent
changes, other than touching the same code.

--Andy

>
> Thanks,
>
>        tglx
>
