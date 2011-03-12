Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1CLVqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:46:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51956 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1CLVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Npzs3KI4VQM+joTdgNoQUV4Z60l2VKkJb5RFhA7w5VZbzaSFH+KbvuvcJ2Wl6Mo3bG
         9RvAaCAl7FoMNPef3cAWBoLOGJQLcpsYNzRguELKTW6qX7XX+zHzL4wccbVIo6DBhckB
         rHAjc1RcK/avcFnUNoDRiQ3uIDn6z9YuRbIRU=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Robin Becker <replabrobin@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robin Becker <robin@reportlab.com>
Subject: Re: [PATCH] arm: mach-kirkwood: add led in sheevaplug-setup.c
References: <1299943965-8626-1-git-send-email-robin@reportlab.com>
Date: Sat, 12 Mar 2011 22:46:07 +0100
In-Reply-To: <1299943965-8626-1-git-send-email-robin@reportlab.com> (Robin
	Becker's message of "Sat, 12 Mar 2011 15:32:45 +0000")
Message-ID: <87y64k8128.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Robin" == Robin Becker <replabrobin@gmail.com> writes:

 Robin> From: Robin Becker <replabrobin@gmail.com>
 Robin> This patch adds a second, red, led for the standard sheevaplug.
 Robin> The sheeva_esata mpp config is left unchanged.

 Robin> Tested on a standard sheevaplug

 Robin> Signed-off-by: Robin Becker <robin@reportlab.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

I had a look at this 2nd LED just the other week and was going to send a
patch to add it.

-- 
Bye, Peter Korsgaard
