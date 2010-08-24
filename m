Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0HXRmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:42:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21921 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab0HXRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:42:10 -0400
Date: Tue, 24 Aug 2010 10:40:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: System silently not booting with 2.6.35 nor with 2.6.35.3 -- It
 works fine with 2.6.32.x and 2.6.18.x
Message-Id: <20100824104046.a8018469.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikQXxmzC1LxOC7wUWj40nRyLvBgGa0NO3_2s5oX@mail.gmail.com>
References: <AANLkTinzaRBaWX9EJTAt70Qk+bifFicUUGh=vRJaWL+N@mail.gmail.com>
	<AANLkTikQXxmzC1LxOC7wUWj40nRyLvBgGa0NO3_2s5oX@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 15:58:38 +0200 Richard Hartmann wrote:

> As a follow-up, we restarted with a minimal confugiration from scratch and
> it boots. Please disregard the lacking root filesystem, that is of no concern
> to us atm. Note that there is one special char in the paste below. No idea
> where that is coming from.
> 
> I will try to hunt down the option(s) that caused this, but if anyone has any
> suggestions...


I would try enabling CONFIG_DEVTMPFS and CONFIG_DEVTMPFS_MOUNT.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
