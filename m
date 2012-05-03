Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2ECMky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:40:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35644 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2ECMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:40:53 -0400
Date: Thu, 3 May 2012 21:40:46 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page
 fault
Message-Id: <20120503214046.178f62e646836e6e9e210810@gmail.com>
In-Reply-To: <4FA278B6.5090208@linux.vnet.ibm.com>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
	<4F9777A4.208@linux.vnet.ibm.com>
	<20120426234535.GA5057@amt.cnet>
	<4F9A3445.2060305@linux.vnet.ibm.com>
	<20120427145213.GB28796@amt.cnet>
	<20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
	<4FA0C8A7.9000001@linux.vnet.ibm.com>
	<20120503091558.866e158916f0dd67daf5a9a2@gmail.com>
	<4FA278B6.5090208@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2012 20:23:18 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Takuya, i am sorry, please forgive my rudeness! Since my English is
> so poor that it is easy for me to misunderstand the mail.　:(

Me too, I am not good at reading/speaking English!
No problem.

> > But this is your work and it's up to you.  Although I was thinking to help
> > your measurement, I cannot do that knowing the fact that you would not
> > welcome my help.

> Of course, any measurement is appreciative!

I am interested in checking the improvement in my own eyes.

> > Sorry for disturbing.

> Sorry again.

No problem, really.
Let's discuss more from now on!

What I am really worrying about is the lack of review in this area.
I am not the person who is good at MMU things.

We should collect more comments if possible from other developers.

Thanks,
	Takuya
