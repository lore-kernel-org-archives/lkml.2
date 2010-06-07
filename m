Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0FGCdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 22:33:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57173 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0FGCdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A+k3fAf6nX6oqe0MGS5QFOaQ+qpI/a5/cklJ7Z7/upHem08inMmFazOExaCICtX+7B
         CmEa5hs0hOWEQ4y/eFKr/wcaue/Hs0AD8NQLdKNrs7HMnJhh84qO9h4yh0o21wrl41LT
         ezFOYlYkDwDe2z6opUHK7D7SLD20LfCVmmxiU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
Date: Mon, 7 Jun 2010 12:33:36 +1000
Message-ID: <AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Dave Airlie <airlied@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 2:25 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Sun, Jun 6, 2010 at 5:52 PM, Tejun Heo <htejun@gmail.com> wrote:
>> On 06/06/2010 05:48 PM, Tejun Heo wrote:
>>> Can you please try w/o KMS just in case?
>
> 2 out of 2 attempts without KMS worked without any OOPS.
> Sorry to have bother you with this, it now really looks KMS related.
>
>> Also, does it always crash the same way?

Just an initial guess does the vt.c patch in thread

"Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)"

help any?

I can't think off hand of any KMS patch that could have caused it
(though there were quite a few).

Dave.
