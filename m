Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1DLMBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:01:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38009 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1DLMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R7raMMs1ju9DhlxVX9ZYEKADCieVF1J4zMhwgInIE6RzSlUREEQrjVJtB3+TZJVVS9
         3j2odyELgastnMdWdMSlJfhE6pWIItyowGxzVOYzn7z/xbwMHyQJF/7PzkGFzHhj78OC
         v5HoNfZog7jQumhYGrx+tHqXkOzaQFc7ZDZB8=
MIME-Version: 1.0
In-Reply-To: <20110411231843.GB2061@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
	<BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
	<BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
	<BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
	<BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
	<20110411231843.GB2061@nowhere>
Date: Tue, 12 Apr 2011 14:01:00 +0200
Message-ID: <BANLkTinHk7fVi62_Xftwn_0WLOzkS4jggw@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 1:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Apr 11, 2011 at 10:40:18AM +0200, Bastien ROUCARIES wrote:
>> Any news ? Can I test some patch ?
>>
>> Bastien
>
> I have a box currently running two parallel loops of git pull.
> It has run for two hours now and nothing happened, I'm going to
> let that wheel run the whole night and see tomorrow.
>
> In the meantime I'm preparing another box with more CPUs to run
> more parallel git pull. Hopefully I could stress it enough to
> reproduce.
>
As mentionned by thomas I do not know why but running kmail fetching
an imap account in parallel of git increase the lookup rate.

Thanks for trying to reproduce.

Bastien
