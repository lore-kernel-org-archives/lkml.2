Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2FAHou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 03:44:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44611 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab2FAHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 03:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <1338380201.26856.268.camel@twins>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	<1337845936.9783.57.camel@laptop>
	<CABPqkBSwpUHYcq89K-DYwa-6+hV2zNN5t2_22VHV4ROVUWsoGA@mail.gmail.com>
	<1338380201.26856.268.camel@twins>
Date: Fri, 1 Jun 2012 09:44:42 +0200
Message-ID: <CABPqkBStZuVtyJwD0MVFV5+G4nGMuhXy3GRZbgNY2wYyHDWNxQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-05-24 at 09:58 +0200, Stephane Eranian wrote:
>> > OK, so how about I queue the below and if the u-code updates gets
>> > released before this hits Linus' tree we'll make it all go away ;-)
>> >
>> Let me get confirmation from Intel today before we do this.
>
> Any word from them?

They are double-checking on this.
