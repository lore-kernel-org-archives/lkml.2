Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab2EIQXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:23:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58049 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab2EIQXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120509161203.GK22082@ZenIV.linux.org.uk>
References: <1336577114.3638.23.camel@lappy> <20120509161203.GK22082@ZenIV.linux.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 9 May 2012 18:23:30 +0200
Message-ID: <CA+1xoqdEFOBPSng99jFcgj9Un9ZguXqKhXYdDCeKv3k5nLrC6Q@mail.gmail.com>
Subject: Re: vfs: INFO: possible circular locking dependency detected
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, May 09, 2012 at 05:25:14PM +0200, Sasha Levin wrote:
>> Hi all,
>>
>> I've started seeing the following warning while fuzzing inside a KVM guest with the latest -next:
>        It's not a realistic attack, fortunately, since you need root
> to get past open_exec() on any of those...  Wait.  How _did_ you get
> past open_exec(), anyway?  MAY_EXEC is not supposed to be granted on
> anything that has no exec bits at all and AFAICS none of those files
> have them.

You could chmod +x and run them, no?
