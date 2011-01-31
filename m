Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1AaX3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:29:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59423 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1AaX3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:29:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=jYM+koeNqDSNMA1/P3NSn9EPB6H716it2Qn+sQe4fwZZ3mQ/1DxXAsA1ehTnWWUIn+
         Qi5DL+pWeD8lycRKq4xmWtrhp7wEoN1PRuUu9cxZVrJca1HSt2WMN2sYVIafw4b7F16r
         4ppv2xlcfy9zEZx0HpyTjJ71gk8FikhPIyTRU=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Jan 2011 15:29:25 -0800
Message-ID: <AANLkTikEhrZmOM3+2jCFXKJh1szd5zKcPxC5HT8NEorQ@mail.gmail.com>
Subject: Kernel wiki for Linux networking
To: netdev@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Etan.Cohen@atheros.com,
        Hai.Shalom@atheros.com, "zhen.xie" <zhen.xie@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://wiki.kernel.org/

We lack a general networking wiki. Can we get a subdomain to start
one? The Documentation/ directory serves its purpose but wikis can
allow for easier updates and allow for more content to be added and
categorized. We have some pages with some content already like:

http://www.linuxfoundation.org/collaborate/workgroups/networking/
http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge

This is obviously outdated:

http://www.linuxfoundation.org/collaborate/workgroups/networking/802.11

And should just point to wireless.kernel.org, but I don't get the
sense that the LF networking site is a home body for any doc updates.

I have found the 802.11 wiki to write proposals [1], summarize
standards [2], and even provide a home body for userspace [3]. I think
something like this can benefit networking in general. Thoughts?

[1] http://wireless.kernel.org/en/developers/DFS
[2] http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
[3] http://wireless.kernel.org/en/users/Documentation

  Luis
