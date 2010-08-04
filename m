Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0HDJOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:14:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55574 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0HDJOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wSXOFyZU4zlPpkrDkwB2eGHj7qinqLs7ytViF/9PeaNie1Fg+32SEcUI1An+c+0Zbo
         yQ2r5SfS7IWIjL2fPAgaYAKOVX65IBUg08jnbSOAeYhp7zRIO1+5tzRHiNhtV28lwfhU
         uoMbxwrnoW2pilFGnRyCSWko6/xfLA/Y2pNnA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
References: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Wed, 4 Aug 2010 16:14:10 +0700
Message-ID: <AANLkTimejYX3OEk9j+L+nWKyBuf7=rJbAOvQGhxJNPxN@mail.gmail.com>
Subject: Re: question about CONFIG_BASE_SMALL
To: Ryan Wang <openspace.wang@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

On Wed, Aug 4, 2010 at 15:38, Ryan Wang <openspace.wang@gmail.com> wrote:
> Hi all,
>
>      I noticed CONFIG_BASE_SMALL in different parts
> of the kernel code, with ifdef/ifndef.
>      I wonder what does CONFIG_BASE_SMALL mean?
> And how can I configure it, e.g. through make menuconfig?

Reply on top of my head: IIRC it means to disable certain things...or
possibly enabling things that might reduce memory footprints.

The goal....to make Linux kernel running more suitable for embedded
system and low level specification machine...

-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
