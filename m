Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab0HFFvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0HFFvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:51:52 -0400
Date: Fri, 6 Aug 2010 01:46:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e crashes with 2.6.34.x and ThinkPad T60
Message-ID: <20100806014610.2bd64d44@katamari>
In-Reply-To: <20100730125614.GB21444@torres.zugschlus.de>
References: <20100724092644.GA13353@torres.zugschlus.de>
	<8DD2590731AB5D4C9DBF71A877482A9001623EC48E@orsmsx509.amr.corp.intel.com>
	<20100730125614.GB21444@torres.zugschlus.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 14:56:14 +0200
Marc Haber <mh+linux-kernel@zugschlus.de> wrote:

>	Capabilities: <access denied>

That's not very useful.

The pcie capabilities are completely missing.
