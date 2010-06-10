Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab0FJQ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:57:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51220 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0FJQ5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Wq3P40GRaICQM6nLWmdIqDFgoXTXYTewdHmr6sa7yMGkRkL3a095/DnrFz+plZWNDN
         3YAi/a4TMx6XjxJbesrOuhfNX2RiPfj3rsWPdXX7ExRpn2rpY3rHqKtJNACduDuQ2qvJ
         GbSr4EY/w3A0tmNrzBr3EFE/3AowshL2sNH4c=
MIME-Version: 1.0
In-Reply-To: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
References: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Thu, 10 Jun 2010 23:56:30 +0700
Message-ID: <AANLkTinXqriwgslQwjmjYaGjiyVK4oh1HZcTwxgWCZkh@mail.gmail.com>
Subject: Re: oom killer and long-waiting processes
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 10, 2010 at 14:17, Ryan Wang <openspace.wang@gmail.com> wrote:
> Hi all,
>
>        I have one question about oom killer:
> If many processes dealing with network communications,
> but due to bad network traffic, the processes have to wait
> for a very long time. And meanwhile they may consume
> some memeory separately for computation. The number
> of such processes may be large.


Please refer to my article here :
http://linuxdevcenter.com/pub/a/linux/2006/11/30/linux-out-of-memory.html

Right now, I can not recall entirely about the rules, but IIRC the
processes that do I/O get lower "score". But that doesn't mean it
won't be killed if free memory amount is really low...

-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
