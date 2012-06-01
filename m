Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab2FAPom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:44:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57091 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909Ab2FAPol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 08:44:19 -0700
X-Google-Sender-Auth: oHo7K9hl1HGsYETlFhdxIjkx8V0
Message-ID: <CA+55aFwk8oYx8EKWdT=5cMTLK7RDz8GQdGmHk2KXwcCq+Bb8PA@mail.gmail.com>
Subject: Re: GIT PULL] ext4 updates for 3.5
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 8:07 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Hmm, this is a regular branch, but you *usually* use a tag, and the
format of the pull-request imples that too:

> ----------------------------------------------------------------
> Ext4 updates for 3.5
>
> The major new feature added in this update is Darrick J. Wong's
> metadata checksum feature, which adds crc32 checksums to ext4's
> metadata fields.  There is also the usual set of cleanups and bug
> fixes.
>
> ----------------------------------------------------------------

Is there perhaps a tag I should pull instead?

               Linus
