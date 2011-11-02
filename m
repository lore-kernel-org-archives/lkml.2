Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1KBVHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab1KBVHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:07:53 -0400
Date: Wed, 2 Nov 2011 22:07:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Undefined Instruction
In-Reply-To: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz>
References: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011, Xin Tong wrote:

> If an application contains an undefined instruction to the processor (
> x86 in particular ) how does the operating system handle it. does the
> operating system just kill the process, or it will throw signals,
> trying to recover from it ?

CPU will trap and kernel will send SIGILL to the process.

-- 
Jiri Kosina
SUSE Labs

