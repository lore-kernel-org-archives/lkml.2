Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1KBVKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:10:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1KBVKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:10:48 -0400
Date: Wed, 2 Nov 2011 22:10:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Undefined Instruction
In-Reply-To: <CALKntY1S9HCQkqVBQSJLUO=L=DfwaSuN4m=akJBKuQ2dxBj4MQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1111022209560.348@pobox.suse.cz>
References: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com> <alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz> <CALKntY1S9HCQkqVBQSJLUO=L=DfwaSuN4m=akJBKuQ2dxBj4MQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011, Xin Tong wrote:

> If i change the kernel, i could have the application stary alive right ?

No need for any kernel changes. You can set your own signal handler for 
SIGILL (but iirc that will make any further behavior of your application 
undefined as long as POSIX is involved).

-- 
Jiri Kosina
SUSE Labs
