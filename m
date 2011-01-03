Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1ACB3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 20:29:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43216 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1ACB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 20:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:in-reply-to:references:user-agent:date:message-id
         :mime-version:content-type;
        b=FBW5jwG+tljMbHS06I5RwjPGslmnCyhSavf32yI4NLBjKvWlMLoa6SO+Rmyz94VD8t
         8h+1uKVjj1z5OSAl8CAlDUAmb+PBg9hrMCmmnr915cWov8yZSP2LmOX5isTOTiI4UDsK
         DUOEXBSoFDVxnLNISOTY0x/Tu+76hMk0nvYhQ=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org
Subject: Re: Measuring startup-time from userspace
In-Reply-To: <4D20FEF0.5020206@mozilla.com>
References: <4D20FEF0.5020206@mozilla.com>
User-Agent: Notmuch/0.5-17-g2d1420b (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 02 Jan 2011 20:29:33 -0500
Message-ID: <87ei8u93lu.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Jan 2011 14:40:48 -0800, Taras Glek <tglek@mozilla.com> wrote:
> The question is, there way for a process to measure time-since-startup 
> without horrible hacks like spawning a new processes?
> 
Would you consider an LD_PRELOAD library to fall into the "hack"
category? I'm not sure when .init section is executed, but it might be
substantially earlier than when _start() is called.

- Ben
