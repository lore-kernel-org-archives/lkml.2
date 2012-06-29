Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2F2Oyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:54:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51489 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752823Ab2F2Oyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:54:31 -0400
Message-ID: <1340981670.6562.25.camel@joe2Laptop>
Subject: Re: [RFC] vsprintf: Add %pb[1-64] specifier to print hex memory dump
From: Joe Perches <joe@perches.com>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 07:54:30 -0700
In-Reply-To: <1340979104-19377-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1340979104-19377-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:11 +0300, Andrei Emeltchenko wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> 
> Add new specifier which may be used to print 1-64 bytes of memory.
> There is often a need to print small (up to 64 bytes) objects like
> bluetooth keys in debug purposes. Currently we have to create special
> function for that.

print_hex_dump() ?

