Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946Ab0EZX7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:59:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934747Ab0EZX7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:59:52 -0400
Message-ID: <4BFDB5A1.2000502@zytor.com>
Date: Wed, 26 May 2010 16:58:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, vgoyal@redhat.com, mjg@redhat.com,
       arozansk@redhat.com, Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH]: Fix checkstack warning in bunzip2 library
References: <20100525223406.9446.46193.sendpatchset@prarit.bos.redhat.com> <20100526165511.b2c1198e.akpm@linux-foundation.org>
In-Reply-To: <20100526165511.b2c1198e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 04:55 PM, Andrew Morton wrote:
> hm, I'm not sure that checkstack warnings are very relevant in the
> contexts where this code executes, but the change is clean enough and
> squishing a warning is good.

This code may be used by squashfs or btrfs, at least in the future, and
in those contexts it's highly relevant indeed.

	-hpa
