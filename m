Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1F1BRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:17:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab1F1BPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LH8FLl/5r+RlveTwpcOdDXFgS5fAsosPFE7BroCOKuBGVYW8/KpcvR8hSJpssQeWxR
         a2v/177wBwTbOi49gie+o1cnjot9dTGWHFgccrKLOMN7CCW//k4Ik9HS2QsXfIJiU8o2
         G55NK4r4gyop69fKDEPBjg6HKxGw+K4yE6aDI=
MIME-Version: 1.0
In-Reply-To: <BANLkTine1Q7thbLVUb34ZsRZt4q184dZzg@mail.gmail.com>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
	<BANLkTine1Q7thbLVUb34ZsRZt4q184dZzg@mail.gmail.com>
Date: Tue, 28 Jun 2011 06:45:21 +0530
Message-ID: <BANLkTinkTLmrB8P7snBq8XOmiap44f+Fqg@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 6:43 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Fri, Jun 24, 2011 at 5:38 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> /proc/PID/io may be used for gathering private information.  E.g. for
>> openssh and vsftpd daemons wchars/rchars may be used to learn the
>> precise password length.  Restrict it to processes being able to ptrace
>> the target process.
>>
>
> Hmm.. How do I reproduce this, won't they be enough randomness around
> rchar/wchar by the time the attacker reads it?
>
>> ptrace_may_access() is needed to prevent keeping open file descriptor of
>> "io" file, executing setuid binary and gathering io information of the
>> setuid'ed process.

Please NOTE my email address has changed to bsingharora@gmail.com, the
last email has an invalid from header.
I apologize for the inconvenience

Balbir Singh
