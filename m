Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab1CXANv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:13:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63998 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab1CXANu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Nhc7e+LlGhuzE5Wx4dVdb6FAUhr2ZBMH0dO12W85eYx+OYEbdmwWF5Xt0jFYXWJMOC
         M3nNH1SrD7eyqdlKiOKbLny4uz0blMzD8y03Wk9bS/q3LGdNcPRp2vk3kMLiC8bYIm+1
         iAqb6NIU1jfK8LbrUEFvm36QJRs9tz1i1HKMU=
MIME-Version: 1.0
In-Reply-To: <10176.1300925166@redhat.com>
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
 <20110323123745.GA30292@linux-sh.org> <AANLkTi=74mO5UW2MKxQ9RdvqhvCvLonnVKmm24jKYaL4@mail.gmail.com>
 <10176.1300925166@redhat.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 Mar 2011 20:13:29 -0400
X-Google-Sender-Auth: HshsMH_upgz0ovQD8V17yQ-wQHM
Message-ID: <AANLkTin1Yi5H30+V2Hp6SPxxKw3uT16HPgiXe041jUf_@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] NOMMU: support SMP dynamic percpu_alloc
To: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, uclinux-dist-devel@blackfin.uclinux.org,
        uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:06 PM, David Howells wrote:
> Mike Frysinger <vapier@gentoo.org> wrote:
>> but David seems to be afk for a while ?
>
> Yeah...  I moved house and then we had to redecorate and stuff, and whilst all

ah, np

> that was going on, my FRV board has been locked away in storage.

i can send you a free Blackfin board :)
-mike
