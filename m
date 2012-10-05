Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2JEJXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:23:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50803 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab2JEJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:23:38 -0400
Message-ID: <1349429015.3638.25.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for parisc
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Oct 2012 10:23:35 +0100
In-Reply-To: <17400.1349380299@warthog.procyon.org.uk>
References: <17400.1349380299@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 20:51 +0100, David Howells wrote:
> Can you merge the following branch into the parisc tree please.

Just to confirm: this is for testing purposes only ... you'll be sending
the pull requests to Linus?  Because otherwise I'll need a signed pull
request from you.

I should be able to get around to testing this after I've looked at some
of the signal/kernel_thread/execve patches for Al Viro.

James


