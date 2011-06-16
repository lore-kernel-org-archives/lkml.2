Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1FPI6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:58:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54615 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1FPI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W1+TySKHysZJ1b8qFtSXk+FNeT6owG5U5+ndJy8RTf1Psk94OW5i8uZN+ydngIve0z
         LIkEL8EzK1Z8vSUn5qf2M5MiZ5aR08sXsiNvAz9KC1vkOdzRrsF2Zgb9y4iPnyrj2MVm
         i+PMdFF9od4967biZgtg/k+ikzuxySDY4/fy0=
Date: Thu, 16 Jun 2011 12:58:42 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
Message-ID: <20110616085842.GB3215@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <201106161050.27716.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161050.27716.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Jun 16, 2011 at 10:50 +0200, Arnd Bergmann wrote:
> The patches all look good to me implementation-wise.

Thanks for the review!

> I have no opinion on whether it's a good idea to include the feature or not.

Why not?  Have you some specific complains where it can be perhaps too
strong/insufficient/non-configurable?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
