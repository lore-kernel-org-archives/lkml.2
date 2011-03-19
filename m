Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab1CSVuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 17:50:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:37649 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab1CSVuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 17:50:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: 2.6.38 kernel breaks userspace bluetooth management tools
Date: Sat, 19 Mar 2011 21:46:03 +0000 (UTC)
Message-ID: <loom.20110319T223719-154@post.gmane.org>
References: <AANLkTikdco2Ex_xEAgWyOQ9OytQkTqR90Nh2hOnneXSu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.186.195.196 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Firefox/3.6.15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

İsmail Dönmez <ismail <at> namtrac.org> writes:
> According to http://www.bluez.org/the-management-interface/ bluetooth
> management interface has changed in the 2.6.38 kernel and this ends up
> breaking bluetooth management tools (the ones that get your bluetooth
> mouse working) in both KDE & Gnome ( see
> https://bugzilla.novell.com/show_bug.cgi?id=680170 ).

This sounds like http://www.spinics.net/lists/linux-bluetooth/msg10695.html

The fix is on its way. Nothing is deliberately broken.

http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a


Cheers

Mikko

