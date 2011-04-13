Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1DMBPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:15:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757493Ab1DMBPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:15:34 -0400
Date: Tue, 12 Apr 2011 18:18:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC]Documentation:accounting:getdelays.c Fix: warning:
 variable =?UTF-8?Q?=E2=80=98i=E2=80=99?= set but not used
Message-Id: <20110412181821.93a3a17f.akpm@linux-foundation.org>
In-Reply-To: <4DA4F201.9050609@gmail.com>
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
	<20110412172627.4e9c4339.akpm@linux-foundation.org>
	<4DA4F201.9050609@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 17:44:49 -0700 "Justin P. Mattock" <justinmattock@gmail.com> wrote:

> On 04/12/2011 05:26 PM, Andrew Morton wrote:
> > On Tue,  5 Apr 2011 09:02:50 -0700
> > "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
> >
> >> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
> >> Documentation/accounting/getdelays.c: In function ___get_family_id___:
> >> Documentation/accounting/getdelays.c:172:14: warning: variable ___rc___ set but not used [-Wunused-but-set-variable]
> >
> > this?
> 
> there was two warnings with that one..(or atleast that what I am seeing 
> over here).

I don't know what you mean.

What command(s) are you using to build getdelays.o, btw?
