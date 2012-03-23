Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2CWEXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:23:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51266 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2CWEXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120323035601.GB12180@redhat.com>
References: <20120323035601.GB12180@redhat.com>
Date: Thu, 22 Mar 2012 21:23:07 -0700
X-Google-Sender-Auth: _ickROw4h7s6mvo-nuR1t2-FhyM
Message-ID: <CAE9FiQWrdSMgkcDvcHU1pSOgLgBVfwYBf8w7CWtOBhL7xS_2oQ@mail.gmail.com>
Subject: Re: MTRR cleanup output
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Jones <davej@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 8:56 PM, Dave Jones <davej@redhat.com> wrote:
> While noticing that MSR spew, I also noticed this machine is really
> verbose in it's output from the MTRR sanitiser.
>
> http://codemonkey.org.uk/junk/dmesg.txt
>
> Could we do better there? Or is this a case where specifying by hand is
> the only solution ?

those are suggestion for the user to select parameters because the
user may have to lost some memory.

Thanks

Yinghai
