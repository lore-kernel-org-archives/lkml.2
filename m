Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2BKUTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 15:19:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41391 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751691Ab2BKUTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 15:19:07 -0500
Message-ID: <1328991543.11026.8.camel@joe2Laptop>
Subject: Re: [PATCH v7 4/8] seccomp: Add SECCOMP_RET_TRAP
From: Joe Perches <joe@perches.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Date: Sat, 11 Feb 2012 12:19:03 -0800
In-Reply-To: <20120211200346.GA16870@albatros>
References: <1328935151-6908-1-git-send-email-wad@chromium.org>
	 <1328935151-6908-5-git-send-email-wad@chromium.org>
	 <CAObL_7FJ=a-X0UuVuK1p338nAVCes4H8PTe2ji5dOLhrtSaKHQ@mail.gmail.com>
	 <CABqD9hYipmC1Dcx6+VrDM04ik5ysfw0GCypEzdFDBfh5B24jtA@mail.gmail.com>
	 <20120211200346.GA16870@albatros>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-12 at 00:03 +0400, Vasiliy Kulikov wrote:
> On Sat, Feb 11, 2012 at 13:30 -0600, Will Drewry wrote:
> > (As a side note, I realize the CC list has ballooned.  In the next
> > rev, I'll pare it down to active participants and the appropriate
> > lists and not just the get_maintainers.pl output!)
> Add kernel-hardening to CC and remove me and Kees ;)

Should that list be added to MAINTAINERS or
Documentation/ somewhere?


