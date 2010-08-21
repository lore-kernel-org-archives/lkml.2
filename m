Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab0HUJXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:23:40 -0400
Received: from borg.medozas.de ([188.40.89.202]:52063 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0HUJXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:23:38 -0400
Date: Sat, 21 Aug 2010 11:23:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Aijaz Baig <aijazbaig1@gmail.com>
cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: help needed with EXPORT_SYMBOL
In-Reply-To: <1282373834.4080.79.camel@aijazbaig1-desktop>
Message-ID: <alpine.LSU.2.01.1008211120120.23263@obet.zrqbmnf.qr>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 2010-08-21 08:57, Aijaz Baig wrote:

>So why is it that when my netfilter module is exporting something to the
>kernel and im tryin to use it from within a core kernel file, the
>compiler flags a 'undefined reference to' error?

There, you answered yourself. Exports only go one way. And that is
core -> module -> module.

