Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0KYP5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:57:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54012 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0KYP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:in-reply-to:references:user-agent:date:message-id
         :mime-version:content-type;
        b=rusjTl+O+QCdLOcF9ryXIhOD6jQS+98Cwl86BWCHciWDTymDEbGUNJUR+Us571c20x
         8YTkL1o9ni8HVQKvq01IekCq1mYlMVvW3OHFsOhGPpWEhOlC/Y4mHJ8MpG03I1XtPH37
         9WIKv7BYAt+zPZ9NOdS3JDSOIglJflJ3o1oHI=
From: Ben Gamari <bgamari@gmail.com>
To: Niels =?utf-8?Q?M=C3=B6ller?= <nisse@lysator.liu.se>,
        linux-kernel@vger.kernel.org
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
In-Reply-To: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Thu, 25 Nov 2010 10:56:57 -0500
Message-ID: <874ob55rcm.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have spent some time searching the documentation and the net for
> answers, without result, hence I'm posting to this list. I'm not
> subscribed, so please cc any replies.
> 
You may find that responses are more forthcoming if you include the
maintainers for the tcp subsystem and a few of the relevant
drivers. This will ensure that they see your message. The LKML is a
pretty high-traffic list and it is frequently that messages simply
aren't seen. Also, I would definitely start by filing bug reports
against individual drivers; as you said producing packets larger than
the maximum segment size definitely seems like buggy behavior. A bug
report will ensure that the problem doesn't fall through the cracks.
Good luck,

- Ben
