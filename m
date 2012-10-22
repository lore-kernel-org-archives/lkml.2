Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2JVQpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:45:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35129 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754303Ab2JVQpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:45:17 -0400
Message-ID: <1350924315.7502.6.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary line continuations
From: Joe Perches <joe@perches.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        "Ken O'Brien" <kernel@kenobrien.org>, gregkh@linuxfoundation.org,
        swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 09:45:15 -0700
In-Reply-To: <1350911803.7502.4.camel@joe-AO722>
References: <1350781512.16706.3.camel@joe-AO722>
	 <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <18159.1350898659@warthog.procyon.org.uk>
	 <1350908109.5931.28.camel@joe-AO722> <1350910971.28457.3.camel@thor>
	 <1350911803.7502.4.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 06:16 -0700, Joe Perches wrote:
> Line continuations are not normal kernel style.
> Bleat a warning when used outside of a macro definition.
[]
> Maybe this patch:

bad patch, please ignore.


