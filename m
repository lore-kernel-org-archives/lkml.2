Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab1DAQse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:48:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47871 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab1DAQsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aL2665JaXAKzQ6qFcoiTeZDEi7I64rHpcJ7Fj3ClqiYWEOwyMwhviXIDp4uGCKrafo
         MgsKS+6E1yzNGQe1UeCFuMpoaNZQntEs6FC3s/tAiW8gmiSEGo9Jzy4foJYkHkKxfnjD
         phBPlBOdG3A6JqAgiL/xL3Yl2poe4uGGNXn5U=
MIME-Version: 1.0
In-Reply-To: <1264.1301495438@redhat.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
	<1264.1301495438@redhat.com>
Date: Fri, 1 Apr 2011 09:48:31 -0700
Message-ID: <AANLkTi==rGJLQfDXohFZwqCT3m27XWUB4sASzomHWCor@mail.gmail.com>
Subject: Re: [PATCH 00/74] Union mounts version something or other
From: Valerie Aurora <valerie.aurora@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 7:30 AM, David Howells <dhowells@redhat.com> wrote:
> Valerie Aurora <valerie.aurora@gmail.com> wrote:
>
>> As always, git trees for the kernel, util-linux, and e2fsprogs, lots
>> of documentation, and LWN articles describing the various problems
>> unioning file systems will encounter are here:
>>
>> http://valerieaurora.org/union/
>
> The webpage there says "linked_list" is the most recent branch, but that
> doesn't match with your patches posted here.  Is "+ext2_cleanup" the matching
> branch?

That's never up to date, but I just fixed it.  The branch you want is
"ext2_cleanup".  Any branch with "+" at the front is a mistake from
trying to do a git push of a rebased branch.  I deleted it.

-VAL
