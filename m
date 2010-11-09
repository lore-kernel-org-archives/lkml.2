Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0KIFjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:39:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52502 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0KIFjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:39:19 -0500
MIME-Version: 1.0
In-Reply-To: <20101109053440.GV5876@outflux.net>
References: <1289273338.6287.128.camel@dan>
	<20101109053440.GV5876@outflux.net>
Date: Tue, 9 Nov 2010 13:39:18 +0800
Message-ID: <AANLkTikee8A3Un9VoXnGO2n51Vs1Qv=whAbjM5VM=Mrq@mail.gmail.com>
Subject: Re: [Security] [PATCH] Restrict unprivileged access to kernel syslog
From: Eugene Teo <eugeneteo@kernel.sg>
To: Kees Cook <kees.cook@canonical.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, security@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 1:34 PM, Kees Cook <kees.cook@canonical.com> wrote:
> On Mon, Nov 08, 2010 at 10:28:58PM -0500, Dan Rosenberg wrote:
>> The kernel syslog contains debugging information that is often useful
>> during exploitation of other vulnerabilities, such as kernel heap
>> addresses.  Rather than futilely attempt to sanitize hundreds (or
>> thousands) of printk statements and simultaneously cripple useful
>> debugging functionality, it is far simpler to create an option that
>> prevents unprivileged users from reading the syslog.
>>
>> This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
>> dmesg_restrict sysctl.  When set to "0", the default, no restrictions
>> are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
>> the kernel syslog via dmesg(8) or other mechanisms.
>>
>> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
>
> Acked-by: Kees Cook <kees.cook@canonical.com>
>
> This looks good to me -- it leaves the /proc file access alone for
> priv-dropping ksyslogd implementations.

Acked-by: Eugene Teo <eugeneteo@kernel.org>

Looks good to me too. Thanks.

Eugene
