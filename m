Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1FFQKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:10:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46914 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1FFQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=nhTH3GuXlPmWFln+L1odNI34gRpjCMmtfFTaAxv6CANWJ1bmkuHx4q8Qcvz0TuBSDM
         U8Bb2xymUStR0cua3oWoP3G2JyqP9gu0Uf88YiiYZxp+oet6w5PSFJlc3ycqzdADEiBp
         FD95KETaodcV6zBYF26brc6/JBKHpA+tEsZec=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=U1D5V8N4fOtH5_H+j2MaW4ri=Uw@mail.gmail.com>
References: <BANLkTi=U1D5V8N4fOtH5_H+j2MaW4ri=Uw@mail.gmail.com>
From: David Nicol <davidnicol@gmail.com>
Date: Mon, 6 Jun 2011 11:10:19 -0500
Message-ID: <BANLkTinWpwZ3ZmRjvQrBsn9B6MM3qXRjUA@mail.gmail.com>
Subject: Does a framework for notification of completed deferred file system
 tasks belong in VFS, or is it better to stay per-fs?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I wrote a patch for BTRFS that provides a way for user notification of
the completion of a deferred file system task, and envision rewriting
it as a general framework for notification of completion of deferred
tasks within BTRFS in general. But why stop there? Other file systems
defer things, and general hooks for notification of completion of
deferred tasks could go into VFS instead of into particular FS -- or
not.

Thoughts?
