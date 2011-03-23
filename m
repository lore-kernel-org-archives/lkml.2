Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab1CWXJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:09:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab1CWXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=O/6VtgyxSsApUnGZbtayJ71X69nlr1YLAtmraAA2vGi3i97yqv4E/Dp8Xl9QBCZemA
         s2qeTIg06/goNECLCNhww8Xga17Y26P43BuUYCrcZIDFUaLKhl7nCV9N5euviM3lnMyT
         l7aYg4D1DnjNztgKV1S27V7UABckI3BXNZOnA=
MIME-Version: 1.0
In-Reply-To: <20110323123745.GA30292@linux-sh.org>
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org> <20110323123745.GA30292@linux-sh.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 Mar 2011 19:09:06 -0400
X-Google-Sender-Auth: o59YpQH_U6KeYd6porVSDCq9HJs
Message-ID: <AANLkTi=74mO5UW2MKxQ9RdvqhvCvLonnVKmm24jKYaL4@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] NOMMU: support SMP dynamic percpu_alloc
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>,
        uclinux-dist-devel@blackfin.uclinux.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:37, Paul Mundt wrote:
> Looks ok to me. I've got a couple other fixes I'm working on at the
> moment, so I'll roll this in to my nommu tree and send it along.

are you picking up nommu fixes in general now ?  there's a long
standing issue of the firmware subdir not working on nommu due to its
usage of vmap() and i wrote a patch for it, but David seems to be afk
for a while ?
-mike
