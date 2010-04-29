Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab0D3Rrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:47:40 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:39163 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab0D3RrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=w+EnNg1HJRmaj5bmrrbSLrRcdvjFf7B6dKOk2/QRCk5nSi3BIW5pOrW7s9xThe2yMN
         SUX8ULnSR6n4hmDjGYcLbIdrEXXRyd7E4NiQXdHm33fIE5KcSNHWIcWyWIiGfAbIpuXH
         zEx9NOm0gkl8IeFeDNK3zrJ1/hqUJgdoIeDOE=
From: Harald Arnesen <harald@skogtun.org>
To: Tejun Heo <tj@kernel.org>
Cc: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org>
	<87r5lzpgfy.fsf@basilikum.skogtun.org> <4BD89880.40509@kernel.org>
Date: Thu, 29 Apr 2010 12:34:12 +0200
In-Reply-To: <4BD89880.40509@kernel.org> (Tejun Heo's message of "Wed, 28 Apr
	2010 22:20:16 +0200")
Message-ID: <87vdba4kez.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On 04/28/2010 08:42 PM, Harald Arnesen wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>>> The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
>>> causes annoying problems with some editors and tools.  Use (C)
>>> instead.
>> 
>> Why do we need anything there at all?
>
> We don't necessarily need it but it's also pretty rude to strip
> other's copyright notices and other entries use (C), so.... :-)

I meant that:

Copyright © somename
Copyright (C) somename
Copyright somename

all have the same legal meaning.
-- 
Hilsen Harald.
