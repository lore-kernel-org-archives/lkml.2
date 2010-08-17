Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0HQJ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:29:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42677 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab0HQJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=fVU2OBBWsp7TuwT8G4KlAeyN3OBvXUZT6lgUd9LuviEUqLGVafTRW+e7R8hS+ZeWNj
         VnqDPRMk/KGoibxPkHlLv1s88tW7/shnGehOan1ESWQ2FhEz+MXNeyJtBmCPAnob0/cS
         TFMBaBQfV9oF68LN6/AISSUJd7e+GYMZrIpo0=
MIME-Version: 1.0
In-Reply-To: <AANLkTik2VDPSZvMzQ8rv38jBDKmRaM9-TL9nhqxj_VSQ@mail.gmail.com>
References: <AANLkTik2VDPSZvMzQ8rv38jBDKmRaM9-TL9nhqxj_VSQ@mail.gmail.com>
Date: Tue, 17 Aug 2010 13:29:38 +0400
Message-ID: <AANLkTimC=VDH=m9SoDK3BGzk7eCKRj6dEVzU230_kFPH@mail.gmail.com>
Subject: Re: bug LINUX_VERSION_CODE undefined
From: Sergey Naumov <sknaumov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. This is my first message to this list so please be patient.

I have encountered compilation error due to
#define LINUX_VERSION_CODE
in include/linux/version.h

This happens because $(VERSION) variable in the main Makefile has a
value of 2.6.35.2 instead of 2,
so "expr" utility fails to generate LINUX_VERSION_CODE value with an
error "non-numeric argument" or smth.

I have found only one link (
http://www.spinics.net/lists/linux-kbuild/msg03230.html ) to this
issue in the Internet,
but there is no response to it, so I decided to post this message.

Please subscribe me personally to answers to this post.

Sergey Naumov.
