Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0DNVcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:32:14 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59754 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0DNVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=RClfB/SxbkvmfpBj81SmBa0sqNyKt1zOXwlKRmjFJGydSvC0t22g6UpkW+Xey3yWGF
         l5NFANiGfj5GeZ/wM8g73YgcdodflA30VjXIkFY5zhuvfYEevtD+iksDJsi04pDXml+9
         AnUJZr95AOPPF5gqEwbqAIHql9kdjif+pkM2Y=
From: Harald Arnesen <harald@skogtun.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tobias <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc4
References: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org>
	<4BC57F10.8080002@plzk.org>
	<alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org>
Date: Wed, 14 Apr 2010 23:32:07 +0200
In-Reply-To: <alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 14 Apr 2010 07:46:11 -0700 (PDT)")
Message-ID: <874ojd3elk.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 14 Apr 2010, Tobias wrote:

>> -rc4 does not boot on my MacBook v2.1. Unfortunately, I can not add much info
>> on what happens since it's all happening really fast. Last thing I can really
>> see is that KMS takes over (?), outputs a few lines which look ok, last line
>> being something about ata. Here the boot stops.
>
> The absolutely most helpful thing you could do (and it really isn't that 
> complex, just somewhat time-consuming) is to do a "git bisect" to figure 
> out exactly where it started.

As a non-kernel-hacker, I agree fully. "git bisect" is the best
error diagnosing tool ever invented.

I have on two occations bisected kernel problems with the help of the
kernel community, and I have really been impressed by the help I have
got.
-- 
Hilsen Harald.
