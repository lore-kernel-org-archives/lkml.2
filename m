Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0JPGRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 02:17:47 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57287 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0JPGRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 02:17:46 -0400
Date: Sat, 16 Oct 2010 07:17:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Stuart Longland <redhatter@gentoo.org>
cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC MIPS] Update buildtar for MIPS
In-Reply-To: <1286502337-23882-1-git-send-email-redhatter@gentoo.org>
Message-ID: <alpine.LFD.2.00.1010160716270.15889@eddie.linux-mips.org>
References: <1286502337-23882-1-git-send-email-redhatter@gentoo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Stuart Longland wrote:

> This updates buildtar to support MIPS targets.  MIPS may use 'vmlinux'
> or 'vmlinux.32' depending on the target system.

 Or vmlinux.64 -- why don't you handle that too?

  Maciej
