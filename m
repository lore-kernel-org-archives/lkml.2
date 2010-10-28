Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab0J1X5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:57:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab0J1X5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=yF4me6FBMUgUEjzpOrQPJsAWkV+7tr+HMpmXLwM0UT3Jgkd8O6qiww90OfFtPZrN61
         Fv5GpDQtdfkC5TARs93A==
MIME-Version: 1.0
In-Reply-To: <20101022213819.GK10119@count0.beaverton.ibm.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC146D4.7030009@cn.fujitsu.com>
	<20101022213819.GK10119@count0.beaverton.ibm.com>
Date: Thu, 28 Oct 2010 16:57:16 -0700
Message-ID: <AANLkTimO+nzksuv==6Cf7BYH0f_TXKiHFkZH1sT+A8i+@mail.gmail.com>
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup hierarchy
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 2:38 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
>> + *
>> + * The iterating order is: a1, a2, b1, c1, c2, a3. So a parent will be
>> + * processed before its children.
>> + */
>
> You could just say it's a depth-first walk except we process the parent before
> its children.

The standard term for that is "pre-order traversal". You shouldn't
need a diagram.

Paul
