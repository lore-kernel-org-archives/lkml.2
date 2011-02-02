Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1BBUi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:38:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37546 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1BBUiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:38:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HqP+CsVINBbQxX5PE85KBLH36v9GBsAgWqbuytv+GrQiMSusKgHeiPpWWObL6x23sB
         kLPGlDvDu6DQxWOQrjCA==
MIME-Version: 1.0
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
Date: Wed, 2 Feb 2011 21:38:45 +0100
Message-ID: <AANLkTinTrtSzw1pHy_5AmQoKbXmQaZ+wkbnmNCoS4RCX@mail.gmail.com>
Subject: Re: [PATCH 0/5] perf, x86: perf, x86: Add support for AMD family 15h
 core counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 5:40 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch set adds support for AMD family 15h core counters. Major
> changes compared to family 10h counters are:
>
> * Now there are separate northbridge and core counters that resides in
>  different MSR ranges (core: MSRC001_02[0B:00], nb:
>  MSRC001_02[47:40]).
>
That leads me to believe, that Fam15h core and uncore PMUs should
be treated completely separately like the Ming's patch for Nehalem uncore.
That would also be true for the Northbridge support of libpfm4.
