Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1J1Qhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:37:41 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:53753 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1J1Qhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:37:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Gregory Sahanovitch <gsahanovitch@gmail.com>
X-Fcc: ~/Mail/lkml
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE
In-Reply-To: Gregory Sahanovitch's message of  Friday, 28 October 2011 15:18:24 +0200 <CAGgmwq49CQKpMhhOHKTasvaRhripu87sq+wzoTQtdv4vDoE1iQ@mail.gmail.com>
References: <CAGgmwq49CQKpMhhOHKTasvaRhripu87sq+wzoTQtdv4vDoE1iQ@mail.gmail.com>
X-Shopping-List: (1) Impudent money
   (2) Athletic lingering lozenge inhibitions
   (3) Zealous dexterous yies
   (4) Adolescent admonishers
Message-Id: <20111028163736.AEF082C0EB@topped-with-meat.com>
Date: Fri, 28 Oct 2011 09:37:36 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=-v16n0QOxCQA:10
		a=kj9zAlcOel0A:10 a=uGsnhWwkVnbUKbWK974A:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since mmap_min_addr is used to prevent a *malicious* process from maping the
> zero page and then taking advantage of a user-pointer dereference in the
> *kernel code*, I do not see what you gain by guaranteeing that the
> application *that you control* would never exploit such a vulnerability?

The application does sandboxing of untrusted code.
