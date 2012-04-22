Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2DVFSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 01:18:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44735 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2DVFSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 01:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <1334711117.4785.43.camel@smoke>
References: <CANFwon0C46UWTLVSeBTTm_aUCub7qW9d+jm=71h894bRODwyQA@mail.gmail.com>
 <1334711117.4785.43.camel@smoke>
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 22 Apr 2012 13:17:54 +0800
Message-ID: <CANFwon0m8Z56kjK_rSROsh4HHiR91S6F8+g4Ftav-unkzam9ig@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20120406 release(hotcode
 analyzer hotcode.py can output html) include patch for review
To: Geoff Levand <geoff@infradead.org>
Cc: linux-kernel@vger.kernel.org, zen lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geoff,

On Wed, Apr 18, 2012 at 09:05, Geoff Levand <geoff@infradead.org> wrote:
> Hi Hui,
>
> On Sat, 2012-04-07 at 20:21 +0800, Hui Zhu wrote:
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>
> You have done some interesting work, but can I recommend a
> few things?
>
> Please break your patch into a few smaller ones, say, one
> that adds the core kgtp support, one that adds the
> documentation files, one that adds the scripts.  Each patch
> should have a suitable comment that describes the
> changes.  For kgtp the patch for the core support would
> of course have a discussion of the feature and its
> benefits, etc.
>
> Also, please post your patches inline so we can give
> line-by-line comments.  It is difficult to give comments
> when the patch is an email attachment.
>

Thanks a lot for your mail.  I will do all of them according to your mail.

Best.
Hui
