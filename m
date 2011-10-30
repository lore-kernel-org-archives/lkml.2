Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab1J3RJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:09:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab1J3RJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <201106161340.16117.arnd@arndb.de>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
	<201106161050.27716.arnd@arndb.de>
	<20110616085842.GB3215@albatros>
	<201106161340.16117.arnd@arndb.de>
Date: Sun, 30 Oct 2011 18:09:40 +0100
Message-ID: <CAFLxGvxSBV9yF2AjXR5A3e-yLDXqMpS+GUFip1JhtzUc5Q0org@mail.gmail.com>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 12:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 16 June 2011, Vasiliy Kulikov wrote:
>> > I have no opinion on whether it's a good idea to include the feature or not.
>>
>> Why not?  Have you some specific complains where it can be perhaps too
>> strong/insufficient/non-configurable?
>
> No, not at all. I just haven't had the need for this myself, and I'm not
> enough of a security person to judge whether the vulnerability addressed
> by the patch is a relevant one. E.g. if all the sensitive information
> you are hiding in procfs is still available through netlink, your patch
> is pointless. Similarly if there is no recorded case of an attack that
> relies on any of the information in procfs.
>

Is this interface somewhere documented?
IOW how is it possible to get all processes via netlink?

-- 
Thanks,
//richard
