Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1EXNzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:55:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63472 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab1EXNzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rx8YV1H10F8RcnQx5fAEJZ8kpRAcXKoyJUaPa5jEO694JL8hxEX9TZI4UhQK7ql0Xw
         O+KTCPf2xCPOZPj/XiJmmah+wWdaSmjT7D0sGF0eBjJksmj7Her/GNmvYG4bwl3IbXeu
         h+WnzC7r5esCrUWfVRcthcuBy40EKVGL40cps=
MIME-Version: 1.0
In-Reply-To: <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com> <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 24 May 2011 13:54:31 +0000
Message-ID: <BANLkTimEZUSbV9wiQZvzCeztdfeMwaMJwA@mail.gmail.com>
Subject: Re: UNIX Compatibility
To: Theodore Tso <tytso@mit.edu>
Cc: Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 13:06, Theodore Tso <tytso@mit.edu> wrote:
>
> On May 24, 2011, at 7:49 AM, Richard Yao wrote:
>
>> I know that the system call codes used by Linux are not 100% UNIX
>> compatible. Is there anything else in the kernel that is not UNIX
>> compatible? Would modifying these things for UNIX compatibility break
>> anything in userland provided that it is recompiled against the
>> modified sources?
>
> What do you mean by "UNIX compatible?"  API compatibility?
> ABI compatibility?   Which Unix?  Solaris and HPUX and AIX
> are systems which are allowed to use the Unix(tm) trademark,
> but them are not compatible with each other.
>
> So the question you are asking is not well defined.
>
> Also, why are you asking it?   What problem are you trying to solve?
> At this point, Linux is running on far more servers than any of the
> Legacy Unix systems out there, and the ones which are still in
> development (i.e., Solaris and AIX) are have recently been worrying
> about adding Linux compatibility layers (usually at the API level).

Surely something as precarious as hegemony is nothing to boast about.
