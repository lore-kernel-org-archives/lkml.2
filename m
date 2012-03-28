Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2C1AIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:08:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52620 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175Ab2C1AIe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:08:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120327235955.GA1394@thor.bakeyournoodle.com>
References: <20120318184105.GC2095@windriver.com>
	<20120318235114.GA30497@thor.bakeyournoodle.com>
	<20120319145125.GA12142@windriver.com>
	<20120327235955.GA1394@thor.bakeyournoodle.com>
Date: Tue, 27 Mar 2012 20:08:32 -0400
X-Google-Sender-Auth: WWB1c9ASO-soFCUpbmBuMkfEV2M
Message-ID: <CAP=VYLryjxC=9e9ehmX-RHbkEeEthkYj0Knb3OJcQcC488FkPA@mail.gmail.com>
Subject: Re: linux-next: triage for March 18, 2012
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 7:59 PM, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Mon, Mar 19, 2012 at 10:51:25AM -0400, Paul Gortmaker wrote:
>
>> Thanks for the updates.  I've added the am33 and h8300 info.  I don't
>> know what to advise wrt. the frv platform...  there doesn't even appear
>> to be an x86_64 cross that I can steal to try and reproduce it with.
>> ( http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/ )
>
> Look again now: http://kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

Cool.  I'll give that a spin tomorrow and see what happens.

P.

>
> Yours Tony
