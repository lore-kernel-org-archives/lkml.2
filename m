Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1DLT4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:56:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915Ab1DLT4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110412192103.GA13278@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 12:55:24 -0700
Message-ID: <BANLkTin6CTjxJLW49ExgFzS6-vne2gdH5w@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:21 PM, Dave Jones <davej@redhat.com> wrote:
>
> looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
>
> perhaps adding that string to the end of the line would preserve what mount expects ?

Care to test? Otherwise I'll just revert the thing.. It's clearly not
valid behavior to randomly add some new field into the middle of a
/proc file.

                              Linus
