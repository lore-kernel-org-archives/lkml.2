Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1C3QGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:06:22 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49742 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab1C3QGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:06:20 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com
Subject: Re: [PATCH] blk-throttle: don't call xchg on bool
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
	<1292447255-10698-3-git-send-email-vgoyal@redhat.com>
	<m21v1ph639.fsf_-_@igel.home> <20110330131936.GA1291@redhat.com>
X-Yow: Yes, Private DOBERMAN!!
Date: Wed, 30 Mar 2011 18:06:16 +0200
In-Reply-To: <20110330131936.GA1291@redhat.com> (Vivek Goyal's message of
	"Wed, 30 Mar 2011 09:19:36 -0400")
Message-ID: <m2mxkcfv9j.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Also, you also probably need to chagne ->limits_changed assignments?
> Instead of using true/false use 1/0.

That's rather a cosmetical change that can be added on top if it is
deemed useful.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
