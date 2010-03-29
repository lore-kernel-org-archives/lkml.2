Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0C2WBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:01:44 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26871 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0C2WBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:01:43 -0400
Subject: Re: lots of "bridge window ... (disabled)" messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4bb0dbec213331313b@agluck-desktop.sc.intel.com>
References: <4bb0dbec213331313b@agluck-desktop.sc.intel.com>
Content-Type: text/plain
Date: Mon, 29 Mar 2010 16:01:51 -0600
Message-Id: <1269900111.10752.37.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 09:57 -0700, Luck, Tony wrote:
> Hi Bjorn,
> 
> I just booted Linus latest git tree on my Tukwila system. I'm
> seeing a lot of bridge windows marked as disabled. Here's the
> start of a diff of dmesg output comparing a kernel from last
> week to today's kernel (git 01e7770 vs. b72c409):
> 
> < pci 0000:00:01.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
> ---
> > pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)

Nothing changed here except the message.  The bridge windows are
disabled in both cases (same values in base & limit, with base > limit);
I just changed the message from "reg reading" to "(disabled)" because I
thought that would be easier to interpret.

Bjorn


